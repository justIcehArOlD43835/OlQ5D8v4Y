# 代码生成时间: 2025-10-04 05:04:30
# Grape API 的媒体资产管理模块
class MediaAssetAPI < Grape::API
  # 使用中间件以确保请求有效性
  use Rack::MethodOverride

  # 媒体资产管理资源定义
  namespace :media_assets do
    # 获取媒体资产列表
    get do
      # 检查权限等...（省略）
      media_assets = MediaAsset.all
      # 将媒体资产对象转换为 HAL+JSON 格式
      present media_assets, with: MediaAssetRepresenter
    end

    # 创建新的媒体资产
    post do
      # 解析请求中的媒体资产数据
      params = JSON.parse(request.body.read)
      # 创建新的媒体资产实例
      media_asset = MediaAsset.new(params)
      if media_asset.save
        # 如果保存成功，返回新创建的媒体资产实例
        present media_asset, with: MediaAssetRepresenter
        status 201
      else
        # 如果保存失败，返回错误信息
        error!('Unable to create media asset', 400)
      end
    end

    # 通过ID获取单个媒体资产
    params do
      requires :id, type: Integer, desc: 'Media Asset ID'
    end
    route_param :id do
      get do
        media_asset = MediaAsset.find(params[:id])
        if media_asset
          present media_asset, with: MediaAssetRepresenter
        else
          error!('Media Asset not found', 404)
        end
      end

      # 更新媒体资产信息
      put do
        media_asset = MediaAsset.find(params[:id])
        if media_asset.update(params)
          present media_asset, with: MediaAssetRepresenter
        else
          error!('Unable to update media asset', 400)
        end
      end

      # 删除媒体资产
      delete do
        media_asset = MediaAsset.find(params[:id])
        media_asset.destroy if media_asset
        status 204
      end
    end
  end
end

# 媒体资产管理模型
class MediaAsset
  include ActiveModel::Model
  attr_accessor :id, :name, :description, :file_path
  # 此处省略数据库操作代码
end

# 媒体资产的 HAL+JSON 代表
class MediaAssetRepresenter < Roar::Decorator
  include Roar::JSON::HAL
  include Roar::Hypermedia

  property :id, getter: -> { represented.id }
  property :name, getter: -> { represented.name }
  property :description, getter: -> { represented.description }
  property :file_path, getter: -> { represented.file_path }

  # 链接到媒体资产的列表
  link :self do
    "/media_assets/#{represented.id}"
  end

  # 链接到所有媒体资产的列表
  link :collection do
    '/media_assets'
  end
end
