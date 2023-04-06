resource "aws_kms_key" "secrets" {
  enable_key_rotation = true
}

#---------------------------------------------------------------
# External Secrets Operator - Parameter Store
#---------------------------------------------------------------

module "secretstore_role" {
  source                      = "github.com/aws-ia/terraform-aws-eks-blueprints//modules//irsa?ref=v4.26.0"
  kubernetes_namespace        = "external-secrets"
  create_kubernetes_namespace = false
  kubernetes_service_account  = local.secretstore_sa
  irsa_iam_policies           = [aws_iam_policy.secretstore.arn]
  eks_cluster_id              = module.eks.cluster_name
  eks_oidc_provider_arn       = module.eks.oidc_provider_arn
  depends_on                  = [module.eks_blueprints_kubernetes_addons]
}

resource "aws_iam_policy" "secretstore" {
  name_prefix = local.secretstore_sa
  policy      = <<POLICY
{
	"Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter*"
      ],
      "Resource": "arn:aws:ssm:${local.region}:${data.aws_caller_identity.current.account_id}:parameter/${local.name}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:Decrypt"
      ],
      "Resource": "${aws_kms_key.secrets.arn}"
    }
  ]
}
POLICY
}

# Examples of using the secretstore
resource "kubectl_manifest" "secretstore" {
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: ${local.secretstore_name}
  namespace: external-secrets
spec:
  provider:
    aws:
      service: ParameterStore
      region: ${local.region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${local.secretstore_sa}
YAML
  depends_on = [module.eks_blueprints_kubernetes_addons]
}

resource "aws_ssm_parameter" "secret_parameter" {
  name = "/${local.name}/secret"
  type = "SecureString"
  value = jsonencode({
    username = "secretuser",
    password = "secretpassword"
  })
  key_id = aws_kms_key.secrets.arn
}

resource "kubectl_manifest" "secret_parameter" {
  yaml_body  = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${local.name}-ps
  namespace: external-secrets
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: ${local.secretstore_name}
    kind: SecretStore
  dataFrom:
  - extract:
      key: ${aws_ssm_parameter.secret_parameter.name}
YAML
  depends_on = [kubectl_manifest.secretstore]
}

