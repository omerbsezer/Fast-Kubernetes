# Sharing Designs

Share designs with other users and use access controls to manage design permissions and visibility.

In Kanvas, you can share your designs with other members of your organization and teams, and you can control access permissions. This page describes the different access types for designs and how to effectively use them.

{{< alert title="Sharing Views" type="info">}}
You can share and control access to [Views](/kanvas/operator/views) in the same fashion as you do for Designs.
{{< /alert >}}

## Understanding visibility levels

Designs have visibility statuses that defines who can access your designs. These options offer different levels of exposure for content within your workspaces:

- **Private:** Designs with visibility status private define only you, the creator, and the user or team that have access based on granted access permission can view and edit the design. Other users cannot access it unless you explicitly share it with them.[^1]

- **Public:**  Making a design "Public" makes it accessible to anyone on the internet who has the link or discovers it through public channels. By default, users accessing a Public design are granted permissions to view, comment on, and edit the design.

{{< alert title="Why use public" type="info">}}
Public status is useful for sharing designs broadly, for example, as open-source templates, public demonstrations, or for soliciting feedback from a wider community. If your goal is to share broadly only within your organization, consider using a combination of private designs shared with specific organization-wide teams or workspaces.
{{< /alert >}}

- **Published:**  The published visibility setting is designed for sharing designs with a wider audience. Published designs become discoverable to other users and allow them to view, download, and clone the design. Users can find published designs through [Cloud Catalog](/cloud/catalog) ([open catalog](https://cloud.layer5.io/catalog)).

## Granting access to individual users

When you share a design, those users or teams become collaborators. You can share your designs with other users by using the "Share" modal. This modal allows you to grant access to individual users or teams. The following steps show how you can grant access to individual users:

**Accessing the "Share" Modal:**

There are two primary ways to open the "Share" modal for a design:

1. **From an Open design:**
    - First, open your Design or View in Kanvas.
    - Click the main **"Share" button**, which is typically located in the top right corner of the editor interface.

2. **From the Recent Designs list:**
    - Click the **more options icon** (often represented by three vertical dots ⋮) associated with that design.
    - Select **"Share"** from the context menu that appears.

![Ways to open Share modal](/kanvas/designer/sharing/model-where.gif)

Once the "Share" modal is open, type the names or email addresses of the users or teams you want to invite as Collaborators. From the "Share" modal, you can also typically change the overall visibility status of the design (e.g., switching between Private and Public).

![Share Modal](/kanvas/designer/sharing/share-model.png)

## Owner vs. Collaborator

When you share a design, or when a design is shared with you, what you can do with it depends on whether you are the **Owner** or a **Collaborator**.

- **Owner:**
  - You are the Owner if you created the design.
  - As the Owner, you have complete control over your design. This includes:
    - Viewing, editing, and modifying all aspects of the design.
    - Deploying the design.
    - Sharing the design with other users or teams (making them Collaborators) and revoking their access.
    - Changing the design's overall visibility (e.g., from Private to Public).
    - Deleting the design.

{{< alert title="Limitation: Ownership Transfer" type="info">}}
transferring ownership of a design to another user is not currently supported in Kanvas.
{{< /alert >}}

- **Collaborator (Shared User/Team):**
  - When an Owner shares a design with you or your team, you become a Collaborator.
  - As a Collaborator, you can actively work on the design. This typically means you can:
    - View the design details.
    - Modify configurations, add or remove components, and essentially edit the design's content.
    - Deploy the design.
  - However, Collaborators have certain limitations and **cannot**:
    - Delete the design.
    - Re-share the design with other users or teams.
    - Change the design's overall visibility (e.g., from Private to Public).

**How You Get Collaborator Access:**

When an Owner shares a design, they add users or teams as Collaborators. Whether you are added individually or are part of a team that gains access, you receive the standard Collaborator permissions described above.

**Managing Access: Revoking and Inviting**

As the Owner of a design, you can manage who has access to it at any time using the "Share" modal. This allows you to:

- Grant access to new users or teams: Add them as Collaborators on your design.
- Revoke access from existing Collaborators: If someone no longer needs access, you can remove them.

> For example, if Sarah is added as a Collaborator to a design, she can edit it. If the design is shared with the "Engineering Team" and Sarah is a member, she also gains the same Collaborator access to edit the design through her team membership.

{{< alert title="Implications of adding a Design to a Workspace">}}
When you add design to a workspace, it signifies that all teams associated with that workspace will be allowed to access your designs even if it is private. Review your workspace's team assignments in order to verify which users will be granted access.
Learn more about [auditing and assigning Workspace access](/cloud/spaces/workspaces/).
{{< /alert >}}

## Sharing Your Design with a Link

You can easily share a direct link to your design:

1. Open the "Share" modal for your design.
2. Click the **"Copy Link"** button. This button is always available, whether your design is Private or Public.

**How the link works:**

- **For Private Designs:** If your design is Private, copying and sending the link acts as a convenient pointer. However, the recipient **must also be explicitly added as a Collaborator** in the "Share" modal to be able to open and access the design. The link alone does not grant them access if they haven't been given permission.
- **For Public Designs:** If your design's visibility is set to Public, anyone with the link can typically access it according to the permissions defined for Public designs (as discussed in "Understanding visibility levels" – for example, they might be able to view, comment, and edit).

{{< alert title="Link Sharing vs. Permissions" type="info">}}
Using "Copy Link" is a quick way to direct people to your design, but remember that actual access is always controlled by the design's visibility status (Private/Public) and the explicit permissions you've granted.
{{< /alert >}}

## Sharing with Multiple Users via Teams

You can efficiently share your designs with many users at once by sharing with **Teams**. When you share a design with a team, all members of that team become Collaborators on the design, gaining the standard Collaborator permissions.

There are two primary ways to share designs with teams:

1. **Direct Sharing via the "Share" Modal:**
    - You can add a team as a Collaborator directly through the **design's** "Share" modal, similar to how you add individual users. This gives the team explicit access to that specific **design**.[^2]

2. **Indirect Sharing via Workspace Association (Intended Mechanism):**
    - Another way access is intended to be managed for teams is through **Workspaces**. The general idea is:
        1. Place your **design** (e.g., a Private Design) into a Workspace.
        2. Assign one or more Teams to that same Workspace.
        3. By this association, members of the assigned Team(s) should then inherit access to the **designs** within that Workspace, including Private designs.

> Learn more about auditing the access permission within [workspace](/cloud/spaces/workspaces/)

[^1]: This functionality is not fully implemented yet. Users might occasionally observe that even when a team is assigned to a workspace, members of that team may not be able to access private designs within that workspace without explicit individual or team-level sharing for the design itself.
[^2]: This feature (direct sharing with teams via the "Share" modal) is not yet fully implemented and is planned for a future update.
