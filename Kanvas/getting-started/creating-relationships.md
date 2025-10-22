---
title: Creating Relationships
description: >
  Relationships identify and facilitate genealogy between Components.
weight: 4
categories: [Designer]
tags: [designs]
draft: false
aliases:
  - /meshmap/getting-started/creating-relationships
---

## Benefits of Using Relationships

- **Improved Visibility**: Clear visual representation of connections between components
- **Enhanced Design**: Make informed decisions about component selection and placement
- **Automated Configuration**: Relationship-driven actions automate configuration of components
- **Increased Flexibility**: Use of selectors and operators provides flexibility in defining relationships
- **Better Understanding**: Easily comprehend the overall structure and dependencies of your managed systems

## What are Relationships

Relationships in Meshery characterize how components connect and interact with each other. They define the structure and dependencies between components in your designs, providing a clear representation of your infrastructure's architecture. Relationships are highly expressive, capturing various forms of interaction between interconnected components regardless of their genealogy.

Meshery recognizes different kinds of relationships:
- **Hierarchical Relationships**: Parent-child relationships showing clear lineage
- **Edge Relationships**: Connections depicting how components interact with each other
- **TagSets Relationships**: Connections based on shared Labels or Annotations

👉 [Learn more about relationships](/kanvas/concepts/relationships/)

## Creating Relationships in Kanvas

Kanvas provides an interactive interface to create and visualize relationships in your designs. Different types of relationships can be initiated in various ways:

### Creating Edge Relationships

Edge relationships represent connections between components that interact with each other. These include network connections, bindings, permissions, and firewall rules. To create an edge relationship:

1. Single-tap on a component to open the edge picker
2. Select the desired relationship type from the edge picker
3. Drag the connection line to a compatible target component
4. Release to establish the relationship

Kanvas will highlight compatible target components as you drag the connection line, making it easier to identify potential relationships.

![Edge Network Relationships](/kanvas/getting-started/images/relationships/EdgeNetwork.gif)

### Creating Hierarchical Parent-Child Relationships

Hierarchical relationships represent parent-child connections between components. To create a hierarchical relationship:

1. Simply drag a child component and drop it inside the parent component
2. The parent-child relationship will be automatically established

For example, dragging a Kubernetes Pod into a Namespace creates a hierarchical relationship where the Namespace is the parent of the Pod.


![Create Parent Child Relationships](/kanvas/getting-started/images/relationships/create-parent-child.gif)

### Creating Inventory Wallet Relationships 

Similar to Parent-Child relationships, Inventory Wallet relationships represent a relationship where a component is directly attached to another component, such as a sidecar container or WASM filter. These are visualized as a badge at the bottom right corner of the parent component with the number of inventory items displayed as a label.

To create an Inventory Wallet relationship:
1. Drag the attachment component (like a sidecar) to the host component
2. After successful creation, a green badge will appear on the host component
3. Clicking on this badge reveals all inventory items


![Create Inventory Wallet Relationships](/kanvas/getting-started/images/relationships/create-inventory-wallet.gif)

### Creating MatchLabel Relationships

MatchLabel relationships (also referred to as TagSets) are automatically created when you input matching labels in the configuration for components. These relationships represent connections between components that share the same Labels or Annotations.

For example, if you add the same label `app: frontend` to both a Service and a Deployment, Kanvas will automatically establish a MatchLabel relationship between them and visualize it as a tagset around the matching components.


![Create MatchLabel Relationships](/kanvas/getting-started/images/relationships/create-matchlabels.gif)

## Keeping Configuration in Sync

Kanvas leverages Meshery's evaluation engine to maintain dependencies between related components. When components are bound by a relationship, changes in one component can automatically update the configuration of related components.

For example, if you create a network relationship between a Service and a Deployment, updating the port in the Service will automatically reflect in the container port configuration of the Deployment. This eliminates the need to manually find and update configurations across multiple components.

The direction of syncronisation depends on the kind of relationships . for parent child relationships implicated configuration of child is updated to match with parent ( eg the value of namespace will be set to name of the parent namespace) . for edge relationships the configuration of the target will be syncronised with the source component eg the port number inside the deployment will be mutated to match the port number in service and similarly for inventory relationships the configuration of parent will get mutated to syncronise with the inventory item 


## Deleting Relationships 

Similar to creation, relationships of different kinds can be deleted in different ways:

1. **Edge Relationships**: Can be deleted by clicking the delete button on the edge menu which can be opened by tapping on the edge

![Delete Edge Relationships](/kanvas/getting-started/images/relationships/delete-edge.gif)

2. **Hierarchical Parent-Child Relationships**: Can be deleted by dragging the child component out of the parent

![Delete Parent Child Relationships](/kanvas/getting-started/images/relationships/delete-parent-child.gif)

<!-- Not implemented yet
3. **Inventory Wallet Relationships**: Can be deleted by clicking the cross icon on the wallet item (coming soon)
4. **MatchLabel Relationships**: Can be deleted by right-clicking on the tagset and selecting delete (coming soon) -->

## What to Expect from Relationships

Relationships help define semantic connections and dependencies between components, showing how one component can influence or modify others. Kanvas relationship visualization makes it easy to understand complex infrastructure details, such as:

- How traffic flows through services and components (using network relationships)
- How resources are sandboxed or provisioned (using parent-child relationships)
- Which components affect or enhance other components through volume mounts, permissions, etc.

## Managing Evaluation/Visualization for Relationships

Individual relationship kinds can be toggled on or off from the relationships section of the designs. When a relationship is toggled off:

- It won't be considered for evaluation or visualization
- It will no longer be identified, validated, synchronized, or visualized in your design

This gives you control over which types of relationships you want to focus on in your infrastructure design.


![Relationships Layers Panel](/kanvas/getting-started/images/relationships/layers-panel-relationships.gif)

