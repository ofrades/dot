{ config, pkgs, ... }: {
  home.packages = with pkgs; [ pavucontrol deepfilternet rnnoise ];

  xdg.configFile."pipewire/pipewire.conf.d/99-deepfilternet.conf".text = ''
    context.modules = [
      {
        name = libpipewire-module-filter-chain
        args = {
          node.description = "DeepFilter Noise Canceling"
          media.name = "DeepFilter Noise Canceling"
          filter.graph = {
            nodes = [
              {
                type = ladspa
                name = "DeepFilter Mono"
                plugin = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so"
                label = "deep_filter_mono"
              }
            ]
          }
          audio.rate = 48000
          audio.position = [ "FL" ]
          capture.props = {
            node.passive = true
          }
          playback.props = {
            media.class = "Audio/Source"
          }
        }
      }
    ]
  '';
}
