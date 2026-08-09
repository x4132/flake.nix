{ config, pkgs, ... }:

{
	services.xserver.videoDrivers = [ "modesetting" ];

	# graphics drivers for intel gpus
	# see: wiki.nixos.org/wiki/Intel_Graphics
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver
			vpl-gpu-rt

			intel-compute-runtime
		];
	};

	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "iHD";
	};

	hardware.enableRedistributableFirmware = true;
	boot.kernelParams = [ "i915.enable_guc=3" ];
}
