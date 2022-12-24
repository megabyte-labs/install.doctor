## Web Applications

This playbook does a bit more than just install software. It also optionally sets up web applications too. If you choose to deploy the default Gas Station web applications on your network, you should probably do it on a computer/server that has a lot of RAM (e.g. 64GB+).

Although a production environment will always be more stable and performant if it is hosted with a major cloud provider, sometimes it makes more sense to locally host web applications. Some applications have abnormally large RAM requirements that could potentially cost thousands per month to host with a legit cloud provider.

We use Kubernetes as the provider for the majority of the applications. It is a production-grade system and although there is a steeper learning curve it is well worth it. Each application we install is packaged as a Helm chart. All of the data is backed up regularly to an encrypted cloud S3 bucket of your choice.

### Helm Charts

The available Helm charts that this playbook completely handles the set up for are listed below.

{{ helm_var_chart }}

### Host Applications

By default, on each computer provisioned using the default settings of Gas Station, several apps are installed on each host. Docker Compose is used to manage the deployment. The default apps include:

{{ hostapp_var_chart }}

You can, of course, disable deploying these apps. However, we include them because they have a small footprint and include useful features. You can also customize the list of apps you wish to include on each host.

#### HTPC

We do not maintain any of the host applications except the ones listed above. However, we do provide the capability of marking a computer being provisioned as an HTPC. Doing this will include a suite of web applications with powerful auto-downloading, organizing, tagging, and media-serving capabilities. Since most people will probably be stepping outside the confines of the law for this, it is not recommended. If you still want to experiment then you can find descriptions of the applications below. The applications are intended to be hosted on a single computer via Docker Compose. The backend for Kodi is included but you should still use the regular installation method for Plex and the front-end of Kodi to view your media collection.

{{ htpc_var_chart }}

### Online Services

Certain parts of the stack rely on cloud-based service providers. All of the providers can be used for free. The providers are generally chosen because their settings need to persist or the functionality that they provide would benefit from a security-hardened SaaS offering.

You can, of course, swap these services out for alternatives. However, our scripts integrate these specific services so if you want to swap them out then some leg work will be necessary.

{{ saas_var_chart }}
