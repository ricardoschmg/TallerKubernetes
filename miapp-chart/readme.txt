1.   Se debe instalar Helm
  

2. Crear el Chart 

   helm create miapp-chart


miapp-chart/
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── _helpers.tpl
├── values.yaml
├── Chart.yaml
└── ...
   
  con este comando se crea la estructura de la carpeta es decir, esto crea una carpeta miapp-chart/ con estructura base (Chart.yaml, values.yaml, /templates, etc.)

3.  Se ajustan los manifiestos que estan dentro  de la carpeta : miapp-chart/templates/:
   
4. Crear el deployment y service
helm install miapp-release ./miapp-chart   

5. Mostrar la url para acceder a la aplicación
    minikube service miapp-release --url

6. Actualizar la aplicación después 
 helm upgrade miapp-release ./miapp-chart  
  



   
