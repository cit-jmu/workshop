json.array!(@settings) do |setting|
  json.extract! setting, :id, :name, :value, :last_changed_by
  json.url setting_url(setting, format: :json)
end
