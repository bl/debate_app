class DebatesController < ApplicationController
  before_action :valid_topic, only: [:new, :create, :index]
  before_action :set_debate, only: [:show, :edit, :update, :destroy]

  # GET /debates
  # GET /debates.json
  def index
    @debates = Debate.search(@topic.id)
  end

  # GET /debates/1
  # GET /debates/1.json
  def show
    @presenter = {
      messages: Message.search(@debate.id),
      status: status
    }
  end

  # GET /debates/new
  def new
    @debate = Debate.new
  end

  # GET /debates/1/edit
  def edit
  end

  # POST /debates
  # POST /debates.json
  def create
    @debate = Debate.new(initial_debate_params)

    respond_to do |format|
      if @debate.save
        format.html { redirect_to [@topic, @debate], notice: 'Debate was successfully created.' }
        format.json { render :show, status: :created, location: @debate }
      else
        format.html { render :new }
        format.json { render json: @debate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /debates/1
  # PATCH/PUT /debates/1.json
  def update
    respond_to do |format|
      #if @debate.update({})
        format.html { redirect_to [@topic, @debate], notice: 'Debate was successfully updated.' }
        format.json { render :show, status: :ok, location: @debate }
      #else
        #format.html { render :edit }
        #format.json { render json: @debate.errors, status: :unprocessable_entity }
      #end
    end
  end

  # DELETE /debates/1
  # DELETE /debates/1.json
  def destroy
    @debate.destroy
    respond_to do |format|
      format.html { redirect_to topic_debates_url, notice: 'Debate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debate
      @debate = Debate.find(params[:id])
    end

    def valid_topic
      @topic = Topic.find(params[:topic_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def debate_params
      params.require(:debate).permit(:id, :topic, :status)
    end

    def initial_debate_params
      {
        owner_id: params[:topic_id],
        status: 'ready'
      }
    end
end
