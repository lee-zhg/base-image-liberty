FROM openliberty/open-liberty:kernel-slim-java8-openj9-ubi

ARG TLS=true

# This script will add the requested XML snippets to enable Liberty features and grow image to be fit-for-purpose using featureUtility.
# Only available in 'kernel-slim'. The 'full' tag already includes all features for convenience.
RUN features.sh

# Add interim fixes (optional)
# COPY --chown=1001:0  interim-fixes /opt/ol/fixes/

# This script will add the requested server configurations, apply any interim fixes and populate caches to optimize runtime
RUN configure.sh

# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi
