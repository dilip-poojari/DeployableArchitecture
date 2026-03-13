apiVersion: datasciencecluster.opendatahub.io/v1
kind: DataScienceCluster
metadata:
  name: default-dsc
  namespace: redhat-ods-operator
spec:
  components:
    dashboard:
      managementState: ${dashboard_enabled}
    workbenches:
      managementState: ${workbenches_enabled}
    datasciencepipelines:
      managementState: ${data_science_pipelines_enabled}
    modelmeshserving:
      managementState: ${model_mesh_enabled}
    kserve:
      managementState: ${kserve_enabled}
      serving:
        ingressGateway:
          certificate:
            type: SelfSigned
        managementState: ${model_serving_enabled}
        name: knative-serving
    ray:
      managementState: ${ray_enabled}
    trustyai:
      managementState: ${trustyai_enabled}
    codeflare:
      managementState: ${code_flare_enabled}