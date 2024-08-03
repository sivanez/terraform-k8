//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group

resource "aws_security_group" "worker_nodes_sg" {
  name_prefix = "worker_nodes_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "allow_tls"
  }
}

//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#:~:text=ingress-,This%20argument%20is%20processed%20in%20attribute%2Das%2Dblocks%20mode.,%2D%20(Required)%20Protocol.%20If%20you%20select%20a%20protocol%20of%20%2D1,-(semantically%20equivalent%20to
resource "aws_security_group_rule" "worker_nodes_ingress" {
  security_group_id = aws_security_group.worker_nodes_sg.id
  from_port         = 0
  protocol          = "-1" //all
  to_port           = 0
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

//https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#:~:text=this%20ingress%20rule.-,egress,End%20range%20port%20(or%20ICMP%20code%20if%20protocol%20is%20icmp).,-The%20following%20arguments
resource "aws_security_group_rule" "wokrker_nodes_egress" {
   security_group_id = aws_security_group.worker_nodes_sg.id
  from_port         = 0
  protocol          = "-1" //all
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]

}
