# Simulation for TASP -- Task-aware Service Placement for Distributed Learning in Wireless Edge Networks

# Introduction
This repo contians the simulation code used in the publication:
> Cong R, Zhao Z, Wang M and Min G. Task-aware Service Placement for Distributed Learning in Wireless Edge Networks[J]. IEEE Transactions on Parallel and Distributed Systems, 2024.

Please copy the following bib info for citations.

<pre><code> @article{cong2024TASP,
  title={Task-aware Service Placement for Distributed Learning in Wireless Edge Networks},
  author={Cong, Rong and Zhao, Zhiwei and Wang, Mengfan and Min, Geyong},
  journal={IEEE Transactions on Parallel and Distributed Systems},
  year={2024},
  publisher={IEEE}
}
</code></pre>


## Description
It is the simulation code used in the work of TASP which has been accepted by TASP '24. In this code, we simulate and compare the three service placement schemes for distributed learning in wireless edge networks.
* TASP:
  This the service placement scheme proposed in this work, in which we propose TASP, a task-aware service placement scheme for distributed learning in wireless edge networks. By carefully considering the structures (directed acyclic graphs) of the distributed learning tasks, the fine-grained task requests and inter-task dependencies are incorporated into the placement strategies. We also exploit queuing theory to characterize the dynamics caused by task uncertainties.
  
* GenDoc:
  
  GenDoc is the service placement and scheduling scheme in wireless edge networks.  In GenDoc, DAGs for service placement is considered. However, GenDoc assumes pre-known and deterministic task DAGs and doesn't consider the queuing delay when multiple sub-tasks are offloaded to the same edge server.
  
* ICE:

  ICE is the service placement and scheduling scheme in wireless edge networks.  In ICE, Gibbs sampling for service cache is exploited. However, ICE overlooks the inter-service dependencies.

  
