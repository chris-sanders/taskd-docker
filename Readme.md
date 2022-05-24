# TaskServer Docker image

This branch uses the `pki` folder from the 1.2.0 version of taskserver. The 1.2.0 branch is considered unstable but verion 1.1.0 was last released in 2015. This backport branch builds an image with the updated `pki` from the 1.2.0 branch which fixes setting expiration dates on the certificates and updates some command line arguments when generating certificates. This should be safe as the taskserver binary is still from the stable 1.1.0 build.

