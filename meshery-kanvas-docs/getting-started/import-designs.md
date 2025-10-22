# Importing a Design

Learn how to import designs from various sources and formats, including Kubernetes manifests, Helm charts, Docker Compose files, and more.

[Kanvas](https://kanvas.new) acts as a powerful bridge, enabling you to import your existing application and infrastructure configurations from a wide variety of standard formats. It transforms these configurations into visual, editable, deployable, and shareable designs. This guide covers how to import designs, the supported formats, and important considerations.

## Accessing the Import Functionality

There are multiple ways to import a design.

{{< tabpane text=true >}}

{{% tab header="Drag and Drop" lang="en" active="true" %}}

You can drag a file from your local computer directly onto the Kanvas canvas to import a design.
![Drag and Drop Import](/kanvas/getting-started/images/importing-designs/drag-drop.gif)

{{< /tab >}}

{{% tab header="From Kanvas Toolbar" lang="en" %}}

The most direct method is to click the **hamburger menu** (☰) in the top-left corner, then select the "Import" button in the Kanvas toolbar.
![File Import Process](/kanvas/getting-started/images/importing-designs/file-import.gif)

{{< /tab >}}

{{% tab header="From Layer5 Cloud" lang="en" %}}

Navigate to the [My Designs](https://cloud.layer5.io/catalog/content/my-designs) page and click the "Import" button.
![Cloud Import Process](/kanvas/getting-started/images/importing-designs/cloud-url.gif)

{{< /tab >}}

{{% tab header="Via GitHub Integration" lang="en" %}}

For a more advanced, repository-based workflow, you can establish a persistent connection between your GitHub account and Meshery. This allows you to browse your repositories and import multiple designs directly.
> Learn more about [GitHub integration](/cloud/getting-started/github-integration/).

{{< /tab >}}

{{< /tabpane >}}

{{< alert type="info" title="Recommendation: Use Kanvas Import" >}}
For the most flexibility, we recommend initiating the import from within Kanvas. This interface gives you the option to either import the configuration as a brand-new design or merge it into a design you currently have open.
{{< /alert >}}

## Importing by Infrastructure Type

Kanvas supports a diverse set of infrastructure types and packaging formats. The following sections provide detailed requirements and instructions for each.

{{< alert type="info" title="Cannot Import Folders Directly" >}}
You can't directly import folders. If your infrastructure definition (like Kustomize or Helm) is in a folder, you must compress it into a single archive file before uploading.
{{< /alert >}}

{{< tabpane text=true >}}

{{% tab header="From Kubernetes Manifests" lang="en" active="true" %}}

Importing from a Kubernetes manifest is the most direct way to bring your existing configurations into Kanvas. This method is suitable for any standard `.yaml` or `.yml` file that conforms to the Kubernetes API specification, as well as for projects managed by Kustomize.

**1. Importing Plain Kubernetes Manifests:** If you have Kubernetes configurations available as standard manifest files, you can import them directly.

- **Supported Packaging Formats:** A standard `.yaml` or `.yml` file containing one or more Kubernetes resource definitions.

**2. Importing a Kustomize Project:** If you manage your Kubernetes configurations with Kustomize, a popular template-free tool for customization, you can import your entire project.

A key requirement when importing a Kustomize project is that you **must provide the entire project directory**, not just the `kustomization.yaml` file. This is because the `kustomization.yaml` file only contains instructions and references to other base manifest files. To correctly render the final configuration, Kanvas needs access to all of these related files.

- **Supported Packaging Formats:** A archive (such as `.zip`, `.tar`, or `.tar.gz`) containing the complete Kustomize project directory. This archive must include the `kustomization.yaml` file and all of its referenced resources.

{{< /tab >}}

{{% tab header="From a Helm Chart" lang="en" %}}

Helm is the standard package manager for Kubernetes. Importing a Helm chart into Kanvas allows you to visualize, manage, and customize complex applications. To ensure a successful import, you must provide the complete packaged chart. Importing individual chart files like `Chart.yaml` or `values.yaml` is not supported.

- **Supported Packaging Formats:**
  - **Chart Archive (`.tgz`, `.tar`, or `.tar.gz`):** The standard gzipped tarball format for distributing Helm charts.
  - **OCI Artifact:** A modern packaging standard. When exported as a file for upload, this can be imported via an `oci://` URI from a container registry.

{{< /tab >}}

{{% tab header="From Docker Compose" lang="en" %}}

This import method provides a convenient bridge for developers looking to migrate their applications from a local Docker-based environment to Kubernetes. Kanvas will parse your `docker-compose.yaml` file and automatically translate your services into their equivalent Kubernetes resources.

- **Supported Packaging Formats:** A standard `.yaml` or `.yml` file. For best compatibility, ensure your Compose file includes a `version` key (e.g., `version: '3.8'`) at the top level.

{{< /tab >}}

{{% tab header="From a Meshery Design" lang="en" %}}

This is Meshery's native format and provides a lossless way to save and import your designs. It preserves all of an application's component configurations as well as the visual layout, annotations, and metadata from the Kanvas designer.

- **Supported Packaging Formats:**
  - **YAML File (`.yml`):** The standard, human-readable file generated when you export a design.
  - **OCI Artifact:** Meshery Designs can also be packaged as OCI artifacts, allowing them to be versioned and distributed via container registries.

{{< /tab >}}

{{< /tabpane >}}

## Frequently Asked Questions

<details>
  <summary>What happens if I drag and drop multiple files onto Kanvas at once?</summary>
  
Each supported file will be imported as a separate, new design. For example, if you drag three different Kubernetes manifest files onto Kanvas, three distinct designs will be created.
</details>

<details>
  <summary>What happens if I select multiple files in the File Upload dialog?</summary>
  
The "File Upload" dialog is designed to process one file or package at a time. If you select multiple files in your operating system's file browser, only the last file in the selection will be processed for import. To import from multiple files, please import them individually.
</details>

<details>
  <summary>After importing a file, can I download my original, unaltered file?</summary>
  
No. When a file is imported, it is converted into a native Meshery Design. The original source file is not stored and cannot be downloaded later. The export function will generate a new file based on the **current** state of your design.
> For more details, see the [Exporting Designs](/kanvas/designer/export-designs/) guide.

</details>

<details>
  <summary>When I import from a Kubernetes manifest, Helm chart, or other type, and choose to merge this file into an existing design, can I download my original file?</summary>
  
When you choose to **merge** a new design into an existing one, Meshery first creates a separate design from your imported file before performing the merge. You can find this newly created design on your [My Designs](https://cloud.layer5.io/catalog/content/my-designs) page.
</details>

<details>
  <summary>Are there any differences, limitations, or special requirements for importing via File Upload, URL, or the GitHub Integration?</summary>
  
Yes. File Upload and URL Import are simple, one-time actions for importing a single design. In contrast, the **GitHub Integration** creates a deep, persistent connection to your GitHub account.

It requires you to authorize the Meshery GitHub App, which then allows you to browse your repositories and select designs directly from the Meshery UI. Most importantly, this integration can enable a GitOps workflow by adding a GitHub Action to your repository that provides visual snapshots of design changes in your pull requests.
</details>

<details>
  <summary>Is there a file size limit for imported designs?</summary>
  
There is no strict limit on the file size itself (e.g., in MB). However, there are limits on the number of **components** a design can contain, which is determined by your current subscription plan. Free accounts are limited to 100 components.

If you attempt to import a design that contains more components than your plan allows, the import will fail with a message stating that the component limit has been exceeded.
> Learn more about [plans](https://layer5.io/pricing).
</details>
