# Copyright 2021 Red Hat, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM registry.access.redhat.com/ubi8/go-toolset:1.21.11-1.1720406008 AS builder

COPY . .

USER 0

# build the aggregator cleaner
RUN umask 0022 && \
    make build && \
    chmod a+x insights-results-aggregator-cleaner

FROM registry.access.redhat.com/ubi9/ubi-micro:latest

COPY --from=builder /opt/app-root/src/insights-results-aggregator-cleaner .

USER 1001

# copy the certificates from builder image
COPY --from=builder /etc/ssl /etc/ssl
COPY --from=builder /etc/pki /etc/pki


# ENTRYPOINT ["/usr/bin/haberdasher"]
CMD ["/insights-results-aggregator-cleaner"]
