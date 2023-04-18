FROM centos:7 as base
WORKDIR /work
COPY docker/setup_base.sh .
RUN sh setup_base.sh && rm -f setup_base.sh

FROM ubuntu:20.04 as tar_builder
COPY docker/setup_tarbuilder.sh .
RUN sh setup_tarbuilder.sh && rm -f setup_tarbuilder.sh

FROM tar_builder as build_tarball
WORKDIR /sitecopy-0.16.6
COPY . .
RUN mv docker/build_tarball.sh .. && rm -rf docker
RUN sh /build_tarball.sh

FROM base as rpm_builder
RUN yum install rpm-build gcc make expat-devel neon-devel gettext
COPY docker/rpm.macros /root/.rpmmacros

FROM rpm_builder as build_srpm
COPY --from=build_tarball /sitecopy-0.16.6.tar.gz .
RUN rpmbuild -ts sitecopy-0.16.6.tar.gz

FROM rpm_builder as build_brpm
COPY --from=build_srpm /work/rpmbuild/SRPMS/sitecopy-0.16.6-1.src.rpm .
RUN rpmbuild --rebuild sitecopy-0.16.6-1.src.rpm

FROM base
COPY --from=build_brpm /work/rpmbuild/RPMS/x86_64/sitecopy-0.16.6-1.x86_64.rpm .
RUN yum install sitecopy-0.16.6-1.x86_64.rpm && rm -f $_
ENTRYPOINT ["sitecopy"]
CMD ["--help"]
