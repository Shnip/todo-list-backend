class TodosController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authorize_access_request!
  before_action :set_todo, only: [:show, :update, :destroy]

  #get todos
  def index
    @todos = current_user.todos

    render json: @todos, include: {
      "attachments_blobs": { 
        only: [:id, :filename] 
      }
    }
  end
  
  #post todos
  def create
    @todo = current_user.todos.build(todo_params)

    if @todo.save
      @todo.attachments.attach(params[:attachments].values) if params[:attachments]

      render json: @todo, include: {
        "attachments_blobs": { 
          only: [:id, :filename] 
        }
      }, status: :created
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end
  
  #get todos/:id
  def show
    render json: @todo
  end

  #patch todos/:id
  def update
    if @todo.update(todo_params)
      @todo.attachments.attach(params[:attachments].values) if params[:attachments]
      
      if params[:willDestroyedBlobs] && params[:willDestroyedBlobs].values.length > 0 then
          ActiveStorage::Attachment.delete(params[:willDestroyedBlobs].values)
      end

      render json: @todo.attachments_blobs, only: [:id, :filename]
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  #delete todos/:id
  def destroy
    @todo.destroy
  end

  private

  def set_todo
    @todo = current_user.todos.find(params[:id])
  end

  def todo_params
    params.permit(:title, :body, :status)
  end

  def attachments_params
    params.permit(attachments: [], willDestroyedBlobs: [])
  end
end
