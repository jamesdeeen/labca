#!/usr/bin/env bash

set -e

flag_skip_redis=true
cloneDir=$(dirname $0)

# For legacy mode, when called from the install script...
SUDO="$1"


if [ "$flag_skip_redis" == true ]; then
    $SUDO patch -p1 < $cloneDir/patches/docker-compose-redis.patch
fi
$SUDO patch -p1 < $cloneDir/patches/docker-compose.patch

$SUDO patch -p1 < $cloneDir/patches/bad-key-revoker_main.patch
$SUDO patch -p1 < $cloneDir/patches/boulder-va_main.patch
$SUDO patch -p1 < $cloneDir/patches/ca_crl.patch
$SUDO patch -p1 < $cloneDir/patches/cert-checker_main.patch
$SUDO patch -p1 < $cloneDir/patches/cmd_shell.patch
$SUDO patch -p1 < $cloneDir/patches/contact-auditor_main.patch
$SUDO patch -p1 < $cloneDir/patches/core_interfaces.patch
$SUDO patch -p1 < $cloneDir/patches/crl-storer_main.patch
$SUDO patch -p1 < $cloneDir/patches/crl_x509_crl.patch
$SUDO patch -p1 < $cloneDir/patches/db_migrations.patch
$SUDO patch -p1 < $cloneDir/patches/errors_errors.patch
$SUDO patch -p1 < $cloneDir/patches/expiration-mailer_main.patch
$SUDO patch -p1 < $cloneDir/patches/linter_linter.patch
$SUDO patch -p1 < $cloneDir/patches/log_log.patch
$SUDO patch -p1 < $cloneDir/patches/log-validator_main.patch
$SUDO patch -p1 < $cloneDir/patches/mail_mailer.patch
$SUDO patch -p1 < $cloneDir/patches/makefile.patch
$SUDO patch -p1 < $cloneDir/patches/notify-mailer_main.patch
$SUDO patch -p1 < $cloneDir/patches/ocsp-responder_main.patch
$SUDO patch -p1 < $cloneDir/patches/policy_pa.patch
$SUDO patch -p1 < $cloneDir/patches/ra_ra.patch
$SUDO patch -p1 < $cloneDir/patches/ratelimit_rate-limits.patch
$SUDO patch -p1 < $cloneDir/patches/reloader_reloader.patch
$SUDO patch -p1 < $cloneDir/patches/startservers.patch
$SUDO patch -p1 < $cloneDir/patches/storer_storer.patch
$SUDO patch -p1 < $cloneDir/patches/updater_updater.patch

sed -i -e "s|./test|./labca|" start.py

sed -i -e "s/berrors.RateLimitError(/berrors.RateLimitError(ra.rlPolicies.RateLimitsURL(), /g" ra/ra.go

mkdir -p "cmd/mail-tester"
cp $cloneDir/mail-tester.go cmd/mail-tester/main.go
perl -i -p0e "s/(\n\t\"github.com\/letsencrypt\/boulder\/cmd\")/\t_ \"github.com\/letsencrypt\/boulder\/cmd\/mail-tester\"\n\1/igs"  cmd/boulder/main.go
