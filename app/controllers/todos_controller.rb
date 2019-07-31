class TodosController < ApplicationController
  before_action :authorize_access_request!
  before_action :set_todo, only: [:show, :update, :destroy]

  #get todos
  def index
    @todos = current_user.todos

    render json: @todos
  end
  
  #post todos
  def create
    @todo = current_user.todos.build(todo_params)
    
    if @todo.save
      render json: @todo, status: :created, location: @todo
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
      render json: @todo
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
    params.require(:todo).permit(:title, :body, :status, todo_files: [])
  end
end
