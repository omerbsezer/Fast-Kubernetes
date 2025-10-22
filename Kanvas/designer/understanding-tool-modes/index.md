# Understanding Tool Modes

Kanvas Designer offers three modes: Default, Pencil, and Connector, which behave differently based on the context in which they are used. Learn how to interact with components and the canvas in each mode.

<!-- set of custom keyboard button classes -->
<link rel="stylesheet" href="https://unpkg.com/keyboard-css@1.2.4/dist/css/main.min.css" />
Kanvas Designer offers three modes: Default, Pencil, and Connector, which behave differently based on the context in which they are used. Understanding these modes is essential for effectively interacting with components and the canvas.

You can switch between mouse modes using hotkeys or tool selection. Here are hotkeys that control your mode:

| Hotkeys                                                          | Description                                                                 |
|------------------------------------------------------------------|-----------------------------------------------------------------------------|
| <button class="kbc-button kbc-button-xs">Spacebar</button>       | Temporarily enables the alternative mouse mode (default mode vs pan mode)  |
| <button class="kbc-button kbc-button-xs">H</button>              | Switches to pan mode (hand icon)                                           |
| <button class="kbc-button kbc-button-xs">Escape / V</button>     | Switches to default mode irrespective of which mode you are currently using.|

## Interacting with Components

{{< tabpane text=true >}}

{{% tab header="Select Tool" lang="en" active="true" %}}

| Action                         | Cursor Style        | Behavior                                                                     | Example                                                                 |
|--------------------------------|---------------------|------------------------------------------------------------------------------|-------------------------------------------------------------------------|
| **Hover**                      | `default (arrow)`   | Nothing                                                                      | ![Click](./default.gif)                                                |
| **Click-and-drag**             | `move`              | Moves component in the direction of the mouse                                | ![Click and drag](./click_and_drag.gif)                                |
| **Click**                      | `default (arrow)`   | Displays component toolbar, resize box, and connection handles               | ![Click](./click.png)                                                  |
| **Double-click (component)**   | `pointer`           | Opens the component configurator                                             | ![Double-click component](./double_click.png)                          |
| **Double-click (textbox)**     | `text`              | Enables text editing inside the component                                    | ![Double-click textbox](./text-box-double-click.gif)                   |
| **Right-click**                | `default (arrow)`   | Opens the circular component context menu                                    | ![Right-click](./right_click.png)                                      |
| **Click-and-hold**             | `crosshair`         | Initiates box selection for selecting multiple components                    | ![Box selection](./select.gif)                                         |
| **Scroll wheel**               | `default (arrow)`   | Pan up or down                                                               | ![Scroll](./scroll_up_down.gif)                                        |
| **Scroll wheel + CMD/CTRL**    | `default (arrow)`   | Zoom in/out                                                                  | ![Zoom](./zoom_in_out.gif)                                             |
| **Horizontal scroll wheel**    | `default (arrow)`   | Pan left or right                                                            | ![Scroll left/right](./scroll_left_right.gif)                          |

{{< /tab >}}

{{% tab header="Pencil Tool" lang="en" action="true" %}}

Pencil lines do not connect individual components, but offer annotating capability, allowing you to take notes and draw annotations to enhance your designs.

| Action                      | Cursor Style        | Behavior                                              | Example                                                        |
|-----------------------------|---------------------|--------------------------------------------------------|----------------------------------------------------------------|
| **Hover**                   | `custom(pencil)`    | Nothing                                                | ![Pencil hover](./pencil_hover.gif)                            |
| **Mouse down + drag**       | `custom(pencil)`    | Start drawing a freeform line                          | ![Freeform line](./pencil.gif)                                 |
| **Mouse down + SHIFT**      | `custom(pencil)`    | Start drawing a straight vertical or horizontal line   | ![Straight line](./mouse_down_plus_shift.gif)                  |
| **Mouse up**                | `custom(pencil)`    | Complete the line and render into a styled component   | ![Mouse up](./mouse_up.gif)                                    |
| **Click**                   | `custom(pencil)`    | Draws ink from the pencil                              | ![Ink](./pencil_ink.gif)                                       |
| **Scroll wheel**            | `custom(pencil)`    | Nothing                                                | ![Mouse down](./mouse_down.gif)                                |
| **Scroll wheel + CMD/CTRL** | `custom(pencil)`    | Nothing                                                | ![Zoom](./zoom_in_out.gif)                                     |

<!-- *Developer notes:*
1. *In the future, the canvas moves with the pen/pencil as they near the edge of the viewport.*
2. *In the future, the scroll wheel will behave as it normally does in default mode.* -->

{{< /tab >}}

{{% tab header="Pen Tool" lang="en" action="true" %}}

The Pen tool operates as a creator of annotation edges. Note that the pen tool has two behaviors depending upon the context in which you initiate the connection.

**To Activate:** `(CMD/CTRL)+E`

<details>
<summary><strong>Connector Behaviors</strong></summary>

- **Component-connect Behavior**: When you click an empty spot on the canvas, and drag to another empty spot on the canvas, you get a joint (aka a terminal node) from which you can create new connections as well as new edge relationships.  
- **Canvas-connect Behavior**: When you click an empty spot on the canvas, and drag to an existing component, you get an annotation edge relationship.

</details>

| Phase                         | Cursor Style | Behavior                                                     | Example                                                         |
|------------------------------|--------------|--------------------------------------------------------------|-----------------------------------------------------------------|
| **1. Click & release**       | `pen`        | Initiate connection                                           | ![Phase 1](./click_release_ptm.gif)                            |
| **2. Click-and-move**        | `pen`        | Move the ghost edge around if a connection was initiated      | ![Phase 2](./click_move_ptm.gif)                               |
| **3. Click while connecting**| `pen`        | Establish and render the connection                           | ![Phase 3](./click_while_connecting_ptm.gif)                   |

<!--
*Developer notes:*
1. *In future, when the connector is released on an empty spot on the canvas, offer a component picker from which users can always choose a “Joint” component.*
2. *Rename PenTerminalNode to “**Joint**”, unless there’s something better to call it.*
-->

{{< /tab >}}

{{% tab header="Pan Tool" lang="en" action="true" %}}

The table below outlines the mouse interaction modes available in <strong>Kanvas</strong> while using, detailing cursor styles and their expected behavior.

| Action                      | Cursor Style        | Behavior                                                 |
|-----------------------------|---------------------|----------------------------------------------------------|
| **Hover**                   | `hand`              | Nothing                                                  |
| **Click-and-hold**          | `grabbing-hand`     | Grab the canvas and pan in the direction of mouse movement |
| **Scroll wheel + CMD/CTRL** | `grabbing-hand`     | Zoom in/out in the direction of the mouse                |
| **Horizontal scroll wheel** | `grabbing-hand`     | Pan left or right in the direction of the mouse          |

{{% /tab %}}

{{< /tabpane >}}
