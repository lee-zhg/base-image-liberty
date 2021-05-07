
# Create your custom Base Java Container Image from Open Liberty

In this sample repo, you will create your custom base Java container image from `Open Liberty` container image `openliberty/open-liberty:kernel-slim-java8-openj9-ubi` in a OpenShift cluster running in IBM Cloud environment. 

This custom base Java container image provides a uniformed starting point for deploying Java applications running on [Open Liberty](https://openliberty.io/) in your organization. 

You are going to create your base image via a tekton pipeline deployed in OpenShift cluster. The pipeline helps you create the base image through a series of tasks.
- setup
- build
- tag-release
- img-release
- img-scan
- helm-release
- gitops

!["tekton-pipeline"](doc/images/tekton-pipeline-01.png)

You can add, remove and modify the tasks in the sample pipeline based on your requirements.


## Pre-requisites

This repo was based on the [Cloud-native toolkit](https://cloudnativetoolkit.dev). 
- `Cloud-native toolkit` must be deployed in your OpenShift cluster. 
- `Cloud-native toolkit CLI` must be installed in your terminal/command window environment

Installation instruction of `Cloud-native toolkit` is available at https://cloudnativetoolkit.dev/getting-started-day-0.


## Steps

You will create your custom base Java container image in a OpenShift cluster running in IBM Cloud environment. 


### Step 1 - Set up local development environment

CLI tools of various open source projects will be used while creating your base container image. 

To enhance the user experience, a simplified installer will be used to install tools and configure the shell environment. The installer will first check if the required tool is available in the path. If not, the missing tool(s) will be installed into the bin/ folder of the current user’s home directory and the PATH variable will be updated in the .bashrc or .zshrc file to include that directory.

The following tools are included in the shell installer:

- IBM Cloud cli (ibmcloud)
- ArgoCD cli (argocd)
- Tekton cli (tkn)
- IBM Cloud fast switching (icc)
- kube-ps1 prompt
- OpenShift cli (oc)
- Kubernetes cli (kubectl)
- JSON cli (jq)
- IBM Garage Cloud CLI (igc)

1. Open a terminal or command window.

1. Set up the shell environment.

    ```
    curl -sL shell.cloudnativetoolkit.dev | bash - 
    
    source ~/.bashrc || source ~/.zshrc
    ```

1. After CLI tools are successfully installed, you should see similar output as below.

    ```
    Downloading scripts: https://github.com/cloud-native-toolkit/cloud-shell-commands/releases/download/0.3.5/assets.tar.gz
    ** Installing argocd cli
    ** Installing tkn cli
    ** Installing kube-ps1
    ** Installing icc
    ** Installing Cloud-Native Toolkit cli

    kube-ps1 has been installed to display the current Kubernetes context and namespace in the prompt. It can be turned on and off with the following commands:
    ```

1. Follow the instruction given at the end of the output to enable the changes in the current terminal session.

1. Verify the shell was installed correctly by checking the oc sync version.

    ```
    oc sync --version
    ```

### Step 2 - Clone the repo

1. Clone the repo locally.

    ```
    git clone https://github.com/lee-zhg/kb-base-image-liberty

    cd kb-base-image-liberty
    ```

### Step 3 - Login to OpenShift cluster

1. Login to OpenShift cluster in the same terminal window. The `oc login` command can be obtained on your OpenShift console. Sample login command

    ```
    oc login --token=sha256~QzR1kT6yaloEUmf4-95r1QELWpoWg8pc1 --server=https://c100-e.us-south.containers.cloud.ibm.com:31574
    ```

### Step 4 - Create namespace `base-image-github`

1. `oc sync` command create a new namespace and also clone a few other resources from the cloud native toolkit deployment.

    ```
    oc sync base-image-github

    Setting up namespace base-image-github
    Setting up namespace: base-image-github
    Checking for existing project: base-image-github
    Creating project: base-image-github
    Copying ConfigMaps
    Copying Secrets
    Setting current project to base-image-github
    ```

### Step 5 - Create Telton Pipeline and associated tasks

1. Create the new Tekton pipeline for creating your custom base container image.

    ```
    oc pipeline -n base-image-github https://github.com/lee-zhg/base-image-liberty --tekton --pipeline ibm-java-maven
    ```
    - base-image-github - is the namespace in your OpenShift cluster.
    - https://github.com/lee-zhg/base-image-liberty - is the github repo url.
    - tekton - you are creating a tekton pipeline.
    - pipeline ibm-java-maven - is the pipeline template used to create your new pipeline.

1. When prompted, enter your `git username`.

1. When prompted, enter your `git password` or `personal access token`. `Git personal access token` is preferred for security reason.

1. When prompted, select if you `Enable the pipeline to scan the image for vulnerabilities?`

1. When prompted, select if you `Enable the pipeline to lint the Dockerfile for best practices?`

1. The `cloud native toolkit` takes your inputs, and create Tekton pipeline and associated resources in your namespace which `base-image-github`.

    ```
    kb-base-image-liberty % oc pipeline -n base-image-github https://github.com/lee-zhg/base-image-liberty --tekton --pipeline ibm-java-maven

    Creating pipeline on openshift cluster in base-image-github namespace
    Retrieving git parameters
    Project git repo: https://github.com/lee-zhg/base-image-liberty.git
    ? Provide the git username: lee-zhg
    ? Provide the git password or personal access token: [hidden]
    Branch: master
    Retrieving available template pipelines from tools
    ? scan-image: Enable the pipeline to scan the image for vulnerabilities? Yes
    ? lint-dockerfile: Enable the pipeline to lint the Dockerfile for best practices? Yes
    Copying tasks from tools
    Copied Pipeline from tools/ibm-java-maven to base-image-github/base-image-liberty
    Creating TriggerTemplate for pipeline: base-image-liberty
    Creating TriggerBinding for pipeline: base-image-liberty
    Creating/updating TriggerEventListener for pipeline: tekton
    Creating new event listener
    Waiting for event listener rollout: base-image-github/el-tekton
    Creating/updating Route for pipeline: tekton
    Creating PipelineRun for pipeline: base-image-liberty
    Creating Github webhook for repo: https://github.com/lee-zhg/base-image-liberty.git

    Pipeline run started: base-image-liberty-1794761aa46

    Next steps:
    Tekton cli:
        View PipelineRun info - tkn pr describe base-image-liberty-1794761aa46
        View PipelineRun logs - tkn pr logs -f base-image-liberty-1794761aa46
    OpenShift console:
        View PipelineRun - https://console-openshift-console.leez-roks-aiops-6ccd7f378ae819553d37d5f2ee142bd6-0000.us-south.containers.appdomain.cloud/k8s/ns/base-image-github/tekton.dev~v1beta1~PipelineRun/base-image-liberty-1794761aa46
    ```

### Step 6 - Configure your pipeline

1. Configure your Tekton pipeline.

    ```
    oc apply -f config/base-image-liberty-pipeline.yaml
    ```

### Step 7 - Start your pipeline

1. You can create you 





## More Details
For more details on how to use this Starter Kit Template please review the [IBM Garage for Cloud Cloud-Native Toolkit Guide](https://cloudnativetoolkit.dev/)


## Next Steps
* Learn more about [Open Liberty](https://openliberty.io/).
* Learn more about augmenting your Java applications on IBM Cloud with the [Java Programming Guide](https://cloud.ibm.com/docs/java?topic=java-getting-started).
* Explore other [sample applications](https://cloud.ibm.com/developer/appservice/starter-kits) on IBM Cloud.

## License

This sample application is licensed under the Apache License, Version 2. Separate third-party code objects invoked within this code pattern are licensed by their respective providers pursuant to their own separate licenses. Contributions are subject to the [Developer Certificate of Origin, Version 1.1](https://developercertificate.org/) and the [Apache License, Version 2](https://www.apache.org/licenses/LICENSE-2.0.txt).

[Apache License FAQ](https://www.apache.org/foundation/license-faq.html#WhatDoesItMEAN)
