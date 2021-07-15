ceph-chef
=========

NOTE: You can find out how to use this cookbook and see how Bloomberg uses it at:
https://github.com/bloomberg/chef-bcs

4.0.0 (2021-07-15)
------------------
- Enable unified_mode for Chef 17

3.0.0 (2020-09-25)
------------------
- Chef 16 fixes

v0.9.0 (2015-11-17)
-------------------

BETA: Documentation needs more clarity and substance. There are still true OS agnostic testing going on. One major
change coming is an update to the newer Chef style of moving provider/resource into classes in the libraries folder.
This will simplify the cookbook structure going forward.

- Support for Chef 12.5+
- Complete Ceph functionality
- Only supports Ceph Hammer and above
- RADOS Gateway (RGW) only supports civetweb style (no Apache)
