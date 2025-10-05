# 代码生成时间: 2025-10-06 03:09:18
# 使用Grape框架实现CSRF防护
# 此程序演示了如何在Grape API中添加CSRF防护机制

require 'grape'
require 'grape-middleware/rack/csrf'

# 定义API
class MyApi < Grape::API
  # 启用CSRF防护
  use GrapeMiddleware::Rack::Csrf,
    raise:           true,
    protect:         [:post, :put, :patch, :delete],
    cookie_name:     :_csrf_token,
    request_forgery_protection_token_generator: :generate_csrf_token,
    request_forgery_protection_token_validator: :validate_csrf_token,
    request_forgery_protection_token_path:       -> { "/",
      Rack::Csrf.token }

  # 定义生成CSRF令牌的方法
  def self.generate_csrf_token
    SecureRandom.hex(16)
  end

  # 定义验证CSRF令牌的方法
  def self.validate_csrf_token(token)
    token == Rack::Csrf.token
  end

  # 定义一个受CSRF防护的端点
  params do
    requires :data, type: String, desc: 'Data payload'
  end
  post '/process_data' do
    # 业务逻辑处理
    "Received data: #{params[:data]}"
  end
end
