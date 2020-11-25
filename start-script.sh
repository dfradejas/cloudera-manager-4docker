#!/bin/bash

/opt/cloudera/cm/schema/scm_prepare_database.sh postgresql -h postgres --scm-host cloudera-manager scm scm
/opt/cloudera/cm/bin/cm-server
