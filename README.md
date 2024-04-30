# Local Lab with VMs/Ansible Setup/Practice

## Premise
I needed some exercise/hands-on experience with Ansible. Plus, I really REALLY like automating stuff. Enter this project.

## Project
**Given two VMs (named nest01/nest02) automate the following tasks:**
- Create a passwordless sudo user for administrative tasks
- Install an Nginx server
- Serve a static webpage through each of those VMs

The reason I chose VMs is because I had a lot of hands-on experience with Docker/containers. Out with the OS-level virtualization, in with the kernel-level virtualization.

## Tech Used
- Virt-manager to set-up the VMs
- Nginx
- Ubuntu 22.04 server as the image
- Ansible (duh 🎉)
- Probably some/a lot of bash

## How It Went
Having no idea the way Ansible worked I dove into the documentation and various tutorials I found on the web.

### Things I Learned from My Searches:
- Ansible tasks can be broken down into roles. Roles are an organised way to structure tasks.
  - This could be applied immediately, effectively creating two roles: `initial-setup`, `nginx`.
- Template files can be really helpful. For example, since I want to see which server is currently serving me, I templated an `index.html` file and added a current host variable to make it more obvious.
- Ansible playbooks can be parameterized. Down the line I wanted to set-up an extra vm (named jumpbox) to run as a reverse-proxy/load-balancer, which required a different configuration, but still shared some tasks with the nests.

## How It Shifted
I got to the point where I set-up the nests and could access them and let them serve me my static webpage. Hooray 🎉🎉🎉🎉🎉🎉🎉🎉🎉🎉

Since the nests serve the exact same thing, why wouldn’t I add a reverse-proxy that would randomly redirect me from either nest? Enter jumpbox (horrible name for now, might make sense later). Jumpbox would sit in front of the nests and serve on its :80 port the content of one of the two nests. This was easily done with Nginx again.

## Ideas to Further Enhance It
I am currently in the process of modifying the lab further. As of now, I have set-up an isolated network, accessible only by the nests and the jumpbox. The jumpbox has access to both the isolated network and the host network (now the name does make sense, doesn’t it?)

### Things to Do:
- Configure Ansible to run through a proxy (jumpbox).
- Automate the creation of the images, with predefined users and ssh-server installed (via cloud-init).
- Automate the creation of the nests.
- Put the website on its own repository and clone it via git to the destination directory.
- Set-up TLS-enabled connections for HTTPS
