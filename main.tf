//creating users
resource "aws_iam_user" "devUserAdmin" {
  name = "Tom"
}

resource "aws_iam_user" "devUser" {
  name = "Jerry"
}

//creating group for ec2 full access and ec2 limited access
resource "aws_iam_group" "ec2user" {
    name = "ec2user"
}

resource "aws_iam_group" "ec2Admin" {
    name = "ec2Admin"
}

//assigning users to group
resource "aws_iam_user_group_membership" "ec2Admin" {
  user = aws_iam_user.devUserAdmin.name

  groups = [
    aws_iam_group.ec2Admin.name
  ]
}

resource "aws_iam_user_group_membership" "ec2user" {
  user = aws_iam_user.devUser.name

  groups = [
    aws_iam_group.ec2user.name
  ]
}

resource "aws_iam_policy" "ec2Policy" {
    name = "ec2-Full-Access"
    policy = data.aws_iam_policy_document.ec2Policy.json
}

data "aws_iam_policy_document" "ec2Policy" {
  statement {
    actions   = ["ec2:*"]
    resources = ["*"]
  }
}
// assign policy to group
resource "aws_iam_policy_attachment" "ec2-attach" {
    name  = "ec2-Full-Access"
    groups = [aws_iam_group.ec2Admin.name]
    roles = [aws_iam_role.ec2_role.name]
    policy_arn = aws_iam_policy.ec2Policy.arn
}

//attaching ec2 full access permission to ec2admin group
resource "aws_iam_group_policy_attachment" "grp-attach" {
    group = aws_iam_group.ec2Admin.name
    policy_arn = aws_iam_policy.ec2Policy.arn
}