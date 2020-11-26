#!/bin/bash

sudo -u cloudera-scm -E /opt/cloudera/cm/schema/scm_prepare_database.sh postgresql -h postgres --scm-host cloudera-manager scm scm
