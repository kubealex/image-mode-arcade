# arcade_os
Git repo hosting the containerfiles for describing the arcade_os's

# Image Mode structure

> [!NOTE]
> You will need to download ROMs according to the ROM emulator you are going to deploy.

The base image that will build the GUI environment is in the `arcade_os` directory.
The you can decide upon the following rom emulators:

- NES Emulator Flatpak in `arcade_nes_flatpak`
- MAME Emulator Faltpak in `arcade_mame_flatpak`
- MAME make build in `arcade_mame_make`. This build will take a long time to compile before it will be ready for deployment.

There are two sample directories for deploying the NES and MAME roms. 

- `nesrom`
- `mamerom`

In these directories replace the `nesrom.nes_replace` or `mamerom.zip_replace` files with the ROM you have downloaded. Replace the filenames accordingly in the `Containerfile` and in the `retro_arcade.sh` files.

# To build the arcade kiosk
1. Change directory to the arcade_base

```bash
cd arcade_os
```

2. Use podman to login to `registry.redhat.io` and the registry where you will be pushing the images.

```bash
podman login --authfile ./auth.json registry.redhat.io
```

3. Create the arcade_base image by runing changing the image tag to your preference

```bash
podman build -t arcade-os:1 -t arcade-os:latest -f Containerfile
```

4. The next steps are similar for building the ROM emulators layers into the OS:

    - arcade_mame_flatpak
    - arcade_nes_flatpak
    - arcade_mame_make (This takes a long time to build due to the make compile)

    We will be using the `arcade_mame_flatpak` as the example.

5. Build the mame rom emulator container file

```bash
cd ../arcade_mame_flatpak
```

```bash
podman build -t arcade-mamerom:1 -t arcade-mamerom:latest -f Containerfile
```

6. Build an arcade rom image. Any of the mame roms can be used.

```bash
cd ../mamerom
```

```bash
podman build -t arcade-mamegame:1 -t arcade-mamegame:latest -f Containerfile
```

7. Push the image and sudo pull the image to the sudo user.

8. Update the config.toml file with your ssh key

9. Create the disk image. This example is for a qcow2 VM disk image.

```bash
sudo podman run \
    --rm \
    -it \
    --privileged \
    --pull=newer \
    --security-opt label=type:unconfined_t \
    -v $(pwd)/config.toml:/config.toml:ro \
    -v $(pwd):/output \
    -v /var/lib/containers/storage:/var/lib/containers/storage registry.redhat.io/rhel10/bootc-image-builder:latest \
    --type qcow2 \
    arcade-mamegame:latest
```

10. Move or copy the VM disk to your pool, in our example that will be:

```bash
sudo mv qcow2/disk.qcow2 /var/lib/libvirt/images/arcade.qcow2
```

11. Install the VM

```bash
virt-install --name arcade \
    --vcpus 2 --memory 4096 \
    --disk /var/lib/libvirt/images/arcade.qcow2,device=disk,bus=virtio,format=qcow2 \
    --os-variant rhel10-unknown --boot uefi --virt-type kvm \
    --video vga
```

6. Run the VM

```bash
sudo virsh start arcade && sudo virt-viewer arcade &
```

7. Build and push your other game roms

8. ssh into the vm and use bootc switch to load another rom

```bash
sudo bootc switch --soft-reboot=required --apply <yourregistry>/<yourgame>:latest
```
