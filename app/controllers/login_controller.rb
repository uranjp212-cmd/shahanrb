class LoginController < ApplicationController
  # def index
  # end
  def new
    # ログイン画面表示
  end

  def create
    shaincd = params[:session][:shaincd]&.strip
    password = params[:session][:password]

    # M_SHAIN から SHAINCD で検索
    shain = Ff2::Shain.find_by(SHAINCD: shaincd)
    p shain
    if shain && shain.valid_password?(password)
      # ログイン成功
      session[:shain_id] = shain.shaincd
      redirect_to new_order_path, notice: "ログインしました。"
    else
      # ログイン失敗
      flash.now[:alert] = "社員コードまたはパスワードが正しくありません。"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:shain_id)
    redirect_to login_path, notice: "ログアウトしました。"
  end
end
