locals {
    name = format("%s-%s", var.name, var.environment)
    vpc_tags = merge({
        "kubernetes.io/cluster/${var.name}-${var.environment}" = "shared"
        },
        var.additional_tags
    )

    public_subnet_tags = merge({
        "kubernetes.io/cluster/${var.name}-${var.environment}" = "shared"
        "kubernetes.io/role/elb"                               = "1"
        },
        var.additional_tags
    )

    private_subnet_tags = merge({
        "kubernetes.io/cluster/${var.name}-${var.environment}" = "shared"
        "kubernetes.io/role/elb"                               = "1"
        },
        var.additional_tags
    )

}