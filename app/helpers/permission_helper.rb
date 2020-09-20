module PermissionHelper
  def amateur_permissions
    {
      self_destroy: false,
      max_tracks: 12,
      max_connectors: 1,
      max_filters: 3,
      max_points: 200,
      next_status: 'pro'
    }
  end

  def pro_permissions
    {
      self_destroy: false,
      max_tracks: 25,
      max_connectors: 2,
      max_filters: 5,
      max_points: 1000,
      next_status: 'music geek'
    }
  end

  def music_geek_permission
    {
      self_destroy: true,
      max_tracks: 'unlimited',
      max_connectors: "unlimited",
      max_filters: 'unlimited',
      max_points: 10_000,
      next_status: 'fuck you bro'
    }
  end

  def next_permissions(status)
    if status == 'amateur'
      {
        self_destroy: false,
        max_tracks: 25,
        max_connectors: 2,
        max_filters: 5,
        max_points: 1000
      }
    elsif status == 'pro'
      {
        self_destroy: true,
        max_tracks: 'unlimited',
        max_connectors: "unlimited",
        max_filters: 'unlimited',
        max_points: 10_000
      }
    end
  end
end
