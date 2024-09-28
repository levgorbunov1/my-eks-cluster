update-kubeconfig:
	aws eks update-kubeconfig --region eu-west-2 --name webapp-eks-cluster

forward-prometheus-port:
	kubectl port-forward -n prometheus pod/prometheus-prometheus-kube-prometheus-prometheus-0  9090:9090 && \
	echo access prometheus UI at: http://localhost:9090

forward-grafana-port:
	echo access grafana UI at: http://localhost:3000 && \
	echo username: admin && \
	echo password: $$(kubectl get secret -n prometheus prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
	kubectl port-forward -n prometheus pod/$$(kubectl get pods -o custom-columns=:metadata.name -n prometheus | grep prometheus-grafana) 3000:3000

ssh:
	sudo ssh -i ~/.ssh/id_rsa.pem ec2-user@$(IP)
