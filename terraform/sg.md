# SUBNET: FRONTEND

- bastion 
    - port:
        - 22 

    - ingress: 
        - 22 - ssh

    - egress: 
        - 0.0.0.0/0 
        - all services port 22

- frontend
    - port: 
        - 80

    - ingress: 
        - 80 (http) from the internet 0.0.0.0/0

    - egress: 
        - voting on port 8080
        - catalogue on port 5000
        - recommendation on port 8080

# SUBNET: BACKEND

- catalogue
    - port: 
        - 5000

    - ingress: 
        - voting

    - egress: 

- Voting
    - port: 
        - 8080

    - ingress: 

    - egress: 
        - catalogue

- Reccomendation
    - port: 
        - 8080

    - ingress: 

    - egress: 

# universal egress
- all services need 0.0.0.0/0 for general internet 

    ## Backend
    ## Frontend
# universal ingress
- all services (except bastion) need ingress for ssh on port 22. 

    ## Backend
        - all backend services need ingress from the frontend SG targeting the backend service port. 
    ## Frontend