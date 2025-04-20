1. Instalar argo

Agrega el repositorio de Helm de Argo CD

  helm repo add argo https://argoproj.github.io/argo-helm
  helm repo update

Instala Argo CD en el namespace argocd
  helm install argo-cd argo/argo-cd -n argocd --create-namespace

2.  Verificar que Argo CD esté corriendo

  kubectl get all -n argocd

  se deberian ver varios pods como argocd-server, argocd-repo-server, etc. todos en estado Running

3. Acceder a la interfaz web de Argo CD
Como en este proyecto se esta trabando con  Minikube, lo más fácil es hacer un port-forward:

kubectl port-forward svc/argo-cd-argocd-server -n argocd 8080:443

Luego Abrir navegador en:
https://localhost:8080

Pero si se esta trabajando con AWS EKS, DigitalOcean Kubernetes, o cualquier proveedor de nube se debe usar un ingress o un LoadBalancer para acceder a Argo CD desde fuera del clúster.



Si se utiliza un Service tipo LoadBalancer
  Solo aplica si tu proveedor de nube soporta LoadBalancer (como AWS o DigitalOcean).

  Cambia el tipo de servicio del argocd-server a LoadBalancer:

    kubectl edit svc argo-cd-argocd-server -n argocd
  
   Buscar esta línea (yaml):
   type: ClusterIP
          Y cambiarla por:

         yaml
   type: LoadBalancer

  Guardar y salir. Luego se obtiene la IP pública:

    kubectl get svc argo-cd-argocd-server -n argocd
   
  se debe  visualizar una columna EXTERNAL-IP. Esa es la IP pública que se puede abrir en tu navegador:

     https://<EXTERNAL-IP>

Si se utiliza un Ingress Controller
Esto es más flexible y profesional, ideal si ya se tiene un controlador de ingress como NGINX o Traefik en tu clúster.

Crear un Ingress para Argo CD habilitándolo con Helm:

  helm upgrade --install argo-cd argo/argo-cd \
  --namespace argocd \
  --set server.ingress.enabled=true \
  --set server.ingress.hosts[0]=argocd.tudominio.com \
  --set server.ingress.tls[0].hosts[0]=argocd.tudominio.com \
  --set server.ingress.tls[0].secretName=argocd-secret

Apuntar el dominio argocd.tudominio.com a la IP pública del controlador de ingress.


4. Obtener a contraseña del usuario admin
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


5. Verifica repositorio en GitHub
El repostirorio debe contener una carpeta llamada por ejemplo k8s/ con los archivos deployment.yaml, service.yaml, etc.

Está en una rama específica (por defecto es main o master).

Por ejemplo:

https://github.com/usuario/mi-repo-git
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml


6. Crea la aplicación en Argo CD (desde CLI)
Asegurase de estar autenticado como admin:

argocd login localhost:8080

Luego ejecutar aajustandoi los datos al repo de gitHub real:

argocd app create miapp \
  --repo https://github.com/ricardoschmg/tu-repo.git \
  --path k8s \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --sync-policy automated


teniendo en cuenta los parámetros asi:

--repo: la URL de tu repo Git.
--path: carpeta dentro del repo donde están los manifiestos (k8s/).
--dest-server: la URL del API server de tu clúster. Para Minikube u on-prem, es https://kubernetes.default.svc.
--dest-namespace: el namespace donde se desplegará tu app (puede ser default o uno personalizado).
--sync-policy automated: para que Argo CD despliegue automáticamente los cambios que hagas en Git.


7. Confirmar despliegue
Desde la interfaz grafica de Argo CD se vera la aplicacion app miapp.

Debería estar en estado Healthy y Synced.

Si se hacen cambios en el repo y al ejecutar git push, Argo actualizará automáticamente el despliegue en el cluster de 
kubernetes.
