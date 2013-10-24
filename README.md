# PactBroker

Add a detailed description of the new service here before your first commit.

Information here will be consumed by the Treasure Map (via the Rumour Mill). Therefore, please retain the existing formatting on this page, importantly:

* The service name at the top of the page
* The location of this description text (between service name and Custodian(s)
* Component Custodian(s)

Other headings can be deleted if they are not relevant.

**NOTE: The following is provided for convenience. Please check it carefully before your first commit.**

## Component Custodian(s)

Enter Custodian(s) here

## Development

Enter any developer instructions here.

### Database setup

Instructions to set up the database for local testing.

Then run migrations:

  $ bundle exec rake db:migrate

### Testing

  $ bundle exec rake

### Running

Instructions to run the service locally.

### Debugging

Any specific debugging tools built in to the service (health check is assumed so don't include that).

### Build

**edit the below and add the correct endpoint**

[Standalone (Bamboo)](http://master.cd.vpc.realestate.com.au/browse/YOUR_NEW_SERVICE_BUILD)

## Deployment

Deployment scripts have been generated using [biq-deploy](https://git.realestate.com.au/business-systems/biq-deploy).

#### EC2 environments

Before deploying to EC2 environments, you may wish to check that the build you wish to deploy has been indexed.

1. Log in into the agent unix box:

  $ rea-ec2-ssh agent-01.biq

2. See the list of versions indexed and verify the expected version in the list:

  $ yum list --showduplicates --enablerepo=rea-el6-dev pact_broker

You can get up an running with these scripts like so (from within the pact_broker project on your local machine):

  $ cd deploy
  $ bundle
  $ bundle exec bin/pact-broker-deploy-ec2 --help

When deploying to an EC2 environment for the first time, you must create a node for the app:

  $ bundle exec bin/pact-broker-deploy-ec2 -t create -s $YOUR_SUBDOMAIN -p dev

The first time the service is deployed, a database must be created. After adding the [required config values](https://git.realestate.com.au/business-systems/pact_broker/blob/master/lib/pact_broker/environment_variables.rb) to the
environment's config-svc, you can run the db provision task:

  $ bundle exec bin/pact-broker-deploy-ec2 -t db_provision -s $YOUR_SUBDOMAIN

Then you are free to migrate the db from then on:

  $ bundle exec bin/pact-broker-deploy-ec2 -t db_migrate -s $YOUR_SUBDOMAIN

To deploy to a test environment (eg biq-qa1):

        $ bundle exec bin/pact-broker-deploy-ec2 -t deploy -s biq-qa1 -p dev -y

#### Production

Refer to the [production deployment readme](https://git.realestate.com.au/business-systems/pact_broker/blob/master/README-ProdDeploy.md).

### Architecture

Any important architectural information.
