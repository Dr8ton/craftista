output "bastion_EIP" {
  description = "The static IP of the Bastion server. "
  value       = aws_eip.eip-bastion.public_ip
}
output "frontend_EIP" {
  description = "The static IP of the Frontend tf server. "
  value       = aws_eip.eip-frontend.public_ip
}

output "frontend_private_IP" {
  description = "The internal IP of the Frontend server. "
  value       = aws_instance.frontend.private_ip
}

output "voting_private_IP" {
  description = "The internal IP of the Voting server. "
  value       = aws_instance.voting.private_ip
}

output "recommendation_private_IP" {
  description = "The internal IP of the Recommendation server. "
  value       = aws_instance.recommendation.private_ip
}

output "catalogue_private_IP" {
  description = "The internal IP of the Catalogue server. "
  value       = aws_instance.catalogue.private_ip
}