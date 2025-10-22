# Working with Tags

Share design with other users and use control access to manage design access permissions and visibility.

You can group components using tags. Tags are key-value pairs that help you organize and categorize components within your design. Tags can be used to visually group components. You can also use tags to filter components and view only those that match the tag criteria.

{{< alert title="Related Concept">}}
Kubernetes resources are capable of being assigned Label and Annotation key/value pairs. When pairs of Labels or Annotations match, a relationship is formed and visualized as shown below.
{{< /alert >}}

## Grouping Components with Tags

To group components using tags, follow these steps.

![Tags](./tagsets.gif)

## Labels and Annotations

Designs support two different types of tags: Labels and Annotations. Labels are often used to identify components and are visible on the design canvas. Annotations are often used to provide additional information about components.

<img alt="Labels and Annotations" src="./group-components.png" width="50%" />

{{< alert title="Performance Consideration" type="warning">}}
Tags are indexed and searchable. However, the performance of design operations may degrade as the number of tags increases. To ensure an optimal user experience, we recommend using tags judiciously and limiting the number of tags used in a design.

Upon loading a design exceeds that exceeds 10 tags within a single design, Kanvas will automatically disable grouping by tags. You can manually enable grouping by tags by clicking the "Group Components" button in the Designer dock.
{{< /alert >}}

{{< alert title="Related Concept">}}
{{< /alert >}}
