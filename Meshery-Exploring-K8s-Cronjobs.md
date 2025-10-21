# LAB: Exploring Kubernetes CronJobs

## Introduction
In this tutorial, we will explore **Kubernetes CronJobs**, a resource that allows you to run jobs periodically at specified intervals.  
We will use **Meshery Playground**, an interactive live cluster environment, to perform hands-on labs for working with CronJobs in Kubernetes.

---

## Prerequisites
- Basic understanding of Kubernetes concepts  
- Access to [Meshery Playground](https://play.meshery.io)

---

## Lab Scenario: Scheduled Backups using CronJobs

### Objective
Learn how to use Kubernetes CronJobs to schedule and automate periodic backups of a sample application.

---

## Steps

### Step 1: Accessing Meshery Playground
1. Log in to the [Meshery Playground](https://play.meshery.io) using your credentials.  
2. Once logged in, navigate to the **Meshery Playground Dashboard**.

---

### Step 2: Deploying an Application

We’ll start by deploying a simple web application that requires periodic backups.

#### Deploying a Web Application in Meshery

1. Navigate to the **Configuration** menu in Meshery.  
2. Select **Designs** from the menu.  
3. Click on the **Import Design** button.  
   ![Configuration menu](https://docs.meshery.io/assets/img/meshery-design/configuration-menu-design-import.png)
4. Fill in the details for your application or design:  
   - **Design File Name**  
   - **Design Type**  
   - **Upload Method** (either *File Upload* or *URL Import*)
5. Click **Import** to upload.  
   ![Click import button](https://docs.meshery.io/assets/img/meshery-design/click-import.png)
6. A confirmation pop-up will indicate successful import and auto-save.  
   ![Design is auto-saved](https://docs.meshery.io/assets/img/meshery-design/design-auto-save.png)
7. Locate your design and click the **Deploy** button.  
   ![Located App](https://docs.meshery.io/assets/img/meshery-design/app-deploy.png)
8. Wait for the **Dry Run** to complete, then click **Deploy**.  
   ![Dry Run](https://docs.meshery.io/assets/img/meshery-design/click-deploy.png)
9. A success pop-up will confirm deployment.  
   ![Deployment Success](https://docs.meshery.io/assets/img/meshery-design/deploy-success.png)

---

### Step 3: Creating a CronJob for Backups

Now, let’s create a CronJob that periodically backs up application data.

#### Creating a CronJob using Kanvas Designer

1. Open the **Kanvas** tab from the left panel.  
2. Ensure you’re on the **Design** tab (top center of the canvas).  
3. From the **Designs** menu, search for your application (e.g., *Minecraft App*).  
   ![Navigate Kanvas](https://docs.meshery.io/assets/img/kanvas/navigate-kanvas.png)
4. Once found, click it to load onto the canvas.  
5. Open the **control panel** at the bottom and choose the **Kubernetes** option.  
6. Search for **CronJob** and add it to the canvas.  
   ![Select CronJob item](https://docs.meshery.io/assets/img/kanvas/select-cronjob.png)
7. Click the **CronJob component** to open its toolbar.  
   ![CronJob Toolbar](https://docs.meshery.io/assets/img/kanvas/toolbar-cronjob.png)
8. Configure:
   - **Name:** `backup-cronjob`  
   - **Schedule:** `0 * * * *` (runs every hour)
   ![CronJob Spec](https://docs.meshery.io/assets/img/kanvas/tool-bar.png)
9. Save your design:
   - Click the **Save As** icon (top right)  
   - Enter a name and click **Save**  
   ![Save CronJob](https://docs.meshery.io/assets/img/kanvas/save.png)
10. Deploy your CronJob:
    - Open the **Action** dropdown → select **Deploy**  
    - Review and correct any errors  
    - Click **Deploy**  
    ![Deploy CronJob](https://docs.meshery.io/assets/img/kanvas/deploy-app.png)
11. A confirmation message will confirm successful deployment.

---

### Step 4: Verifying CronJob Execution

We’ll now verify if the CronJob runs as scheduled and creates backups.

#### Using Kanvas Visualizer

1. Switch to the **Visualize** tab (top center of canvas).  
2. Name your view.  
3. Click the **Filter** icon.  
4. Under **Kind**, select **CronJob** to filter results.  
5. Close the filter — you’ll see only your CronJob resources displayed.  
   ![Visualize CronJob](https://docs.meshery.io/assets/img/kanvas/view.png)

---

### Step 5: Scaling and Updating CronJobs

CronJobs can be modified to adjust schedule or parallelism.

1. Go back to the **Designer** tab.  
2. Open the **design** containing your CronJob.  
3. Locate the **CronJob** component.  
   ![CronJob Component](https://docs.meshery.io/assets/img/kanvas/design-cronjob.png)
4. Click the component to open the toolbar.  
5. Modify your desired specs (e.g., parallelism, schedule).  
6. Adjust **replica** or **parallelism** values as needed.  
   ![Scale CronJob](https://docs.meshery.io/assets/img/kanvas/scale.png)
7. Save the updated configuration.  
   ![Save CronJob](https://docs.meshery.io/assets/img/kanvas/save.png)

Use Meshery Playground to observe the effect on your scheduled backups.

---

### Step 6: Clean-Up

Once done, remove all resources created during this lab.

1. Locate the **CronJob** component in your design.  
2. Select it → click the **Delete** icon.  
   ![Delete CronJob](https://docs.meshery.io/assets/img/kanvas/delete.png)
3. Save your changes.  
   ![Save App](https://docs.meshery.io/assets/img/kanvas/save-app.png)

---

### Step 7: Saving and Sharing

You can share your scenario with other Meshery users.

1. **Save your scenario:**  
   Use the **Save** option in Kanvas Designer and give it a descriptive name.  
2. **Make Design Public:**  
   Toggle visibility to **Public**.  
3. **Share your design:**  
   Copy the link or invite collaborators.  
4. **Invite friends to collaborate:**  
   Share the link for real-time collaboration.  
5. **Confirm sharing settings:**  
   Choose permissions (view, edit, comment).  
6. **Save changes:**  
   Ensure settings are saved and applied.

---

## Conclusion
You’ve successfully explored **Kubernetes CronJobs** using **Meshery Playground**.  
This lab gave you practical experience in automating scheduled tasks such as backups in Kubernetes.  
Continue exploring more Meshery Playground scenarios to deepen your understanding of **cloud-native automation**.
