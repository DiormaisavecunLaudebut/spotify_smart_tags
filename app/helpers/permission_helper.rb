module PermissionHelper
  def amateur_permissions
    {
      self_destroy: false,
      max_tracks: 12,
      max_connectors: 1,
      max_filters: 3
    }
  end

  def pro_permissions
    {
      self_destroy: false,
      max_tracks: 25,
      max_connectors: 2,
      max_filters: 5
    }
  end

  def music_geek_permission
    {
      self_destroy: false,
      max_tracks: 12,
      max_connectors: 1000,
      max_filters: 1000
    }
  end
end
