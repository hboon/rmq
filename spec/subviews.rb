describe 'subviews' do
  before do
    @vc = UIViewController.alloc.init
  end

  it 'should append view to a controller' do
    view = @vc.rmq.append(UIView).get
    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should append! view to a controller and return view without .get' do
    view = @vc.rmq.append!(UIView)
    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should append to the end of the subviews' do
    view = @vc.rmq.append(UIView).get
    @vc.view.subviews[@vc.view.subviews.length - 1].should == view
  end

  it 'should append view to another view' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq(view).append(UILabel).get
    view.subviews.length.should == 1
    view.subviews.first.should == label
  end

  it 'should append a new view to multiple existing views' do
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get

    added_rmq = @vc.rmq.all.append(UIView)
    @vc.rmq.all.length.should == 6
    view.subviews.length.should == 1
    added_rmq.get.include?(view.subviews.first).should == true
  end

  it 'should append view and assign style_name' do
    @vc.rmq.stylesheet = StyleSheetForSubviewsTests
    view = @vc.rmq.append(UIButton, :my_style).get
    view2 = @vc.rmq.append(UIButton).get
    view.rmq_data.style_name.should == :my_style
    view2.rmq_data.style_name.nil?.should == true

    view3 = @vc.rmq.append(SubButtonTest).get
    view3.class.should == SubButtonTest
  end

  it 'should unshift a view to the front of the subviews' do
    orig_length = @vc.view.subviews.length
    view = @vc.rmq.unshift(UIView).get
    @vc.view.subviews.length.should == orig_length + 1
    @vc.view.subviews[0].should == view
  end

  it 'should unshift a view and apply a style' do
    @vc.rmq.stylesheet = StyleSheetForSubviewsTests
    view = @vc.rmq.unshift(UIView, :my_style).get
    @vc.view.subviews[0].should == view
    view.rmq_data.style_name.should == :my_style
  end

  it 'should unshift! view to a controller and return view without .get' do
    view = @vc.rmq.unshift!(UIView)
    view2 = @vc.rmq.unshift!(UIView)
    @vc.view.subviews.length.should == 2
    @vc.view.subviews.first.should == view2
  end

  # TODO test ops in append, unshift, and create

  it 'should add a subview at a specific index' do
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get
    view4 = @vc.rmq.insert(UIView, at_index: 1).get
    @vc.view.subviews[1].should == view4
  end

  it 'should add a subview at a specific index and apply a style' do
    @vc.rmq.stylesheet = StyleSheetForSubviewsTests
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get
    view4 = @vc.rmq.insert(UIView, style: :my_style, at_index: 1).get

    view4.rmq_data.style_name.should == :my_style
    @vc.view.subviews[1].should == view4
  end

  it 'should add a subview below another view' do
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get
    view4 = @vc.rmq.insert(UIView, below_view: view3).tag(:view4).get
    @vc.view.subviews[2].should == view4
    @vc.view.subviews[3].should == view3
  end

  it 'should add a subview below another view and apply a style' do
    @vc.rmq.stylesheet = StyleSheetForSubviewsTests
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view4 = @vc.rmq.insert(UIView, style: :my_style, below_view: view2).tag(:view4).get
    view4.rmq_data.style_name.should == :my_style
    @vc.view.subviews[1].should == view4
    @vc.view.subviews[2].should == view2
  end

  it 'should remove view from controller' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq.append(UILabel).get
    image = @vc.rmq.append(UIImageView).get

    @vc.rmq(UILabel, UIImageView).remove
    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should remove view from superview' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq(view).append(UILabel).get
    image = @vc.rmq(view).append(UIImageView).get

    @vc.rmq(view).children(UIImageView).remove
    view.subviews.length.should == 1
    view.subviews.first.should == label

    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should insert view to the beginning of a views subviews' do
    1.should == 1
    #TODO
  end

  it 'should insert then yield to a block with the rmq object' do
    block_called = false
    @vc.rmq.append(UILabel) do |view|
      view.should.be.kind_of(RubyMotionQuery::RMQ)
      view.get.should.be.kind_of(UILabel)
      block_called = true
    end
    block_called.should == true
  end

  it 'should insert then yield to a block with the created view' do
    block_called = false
    @vc.rmq.append!(UILabel) do |view|
      view.should.be.kind_of(UILabel)
      block_called = true
    end
    block_called.should == true
  end

  describe 'create' do
    it 'should allow you to create a view using rmq, without appending it to the view tree' do
      test_view_wrapped = @vc.rmq.create(SubviewTestView)
      test_view = test_view_wrapped.get

      test_view.superview.nil?.should == true
      test_view.nextResponder.nil?.should == true
      test_view.get_context.should == test_view
    end

    it 'should allow you to create a view with a style, and it to use the stylesheet of view_controller that created it' do
      @vc.rmq.stylesheet = StyleSheetForSubviewsTests
      test_view = @vc.rmq.create(UILabel, :create_view_style).get
      test_view.backgroundColor.should == RubyMotionQuery::Color.blue
    end

    it 'should allow you to create a view outside any view tree, then append subviews and those should use the stylesheet from the rmq that created the parent view' do
      q = @vc.rmq
      q.stylesheet = StyleSheetForSubviewsTests
      test_view_wrapped = q.create(SubviewTestView)
      test_view = test_view_wrapped.get

      test_view_wrapped.parent_rmq.should == q

      test_view_wrapped.wrap(test_view).parent_rmq.parent_rmq.should == q

      sv = test_view.subview
      test_view_wrapped.children.first.get.should == sv
      test_view.subviews.first.should == sv

      test_view.subview.rmq_data.style_name.should == :create_sub_view_style
      test_view.subview.backgroundColor.should == RubyMotionQuery::Color.orange
    end

    it 'should create a default table cell' do
      q = @vc.rmq
      cell = q.append(UITableViewCell, nil, reuse_identifier: 'bar').get
      cell.should != nil
    end

    it 'should allow you to create a table cell while specifying the cell style' do
      q = @vc.rmq
      cell = q.append(UITableViewCell, nil, reuse_identifier: 'foo', cell_style: UITableViewCellStyleSubtitle).get
      cell.detailTextLabel.should != nil
      detail_label = q.build(cell.detailTextLabel).get
      detail_label.should != nil
    end

    it 'should allow you to create a UITableView while specifying the table_style' do
      q = @vc.rmq

      table = q.append(UITableView).get
      table.style.should == UITableViewStylePlain

      table = q.append(UITableView, nil, table_style: UITableViewStyleGrouped).get
      table.style.should == UITableViewStyleGrouped

      table = q.append(UITableView, nil, table_style: UITableViewStylePlain).get
      table.class.should == UITableView
      table.style.should == UITableViewStylePlain

      table_sub = q.append(SubTableTest, nil, table_style: UITableViewStyleGrouped).get
      table_sub.class.should == SubTableTest
      table_sub.style.should == UITableViewStyleGrouped
    end

    it 'should create then yield to a block with the rmq object' do
      block_called = false
      @vc.rmq.create(UILabel) do |view|
        view.should.be.kind_of(RubyMotionQuery::RMQ)
        view.get.should.be.kind_of(UILabel)
        block_called = true
      end
      block_called.should == true
    end

    it 'should create then yield to a block with the created view' do
      block_called = false
      @vc.rmq.create!(UILabel) do |view|
        view.should.be.kind_of(UILabel)
        block_called = true
      end
      block_called.should == true
    end

  end

  describe 'build' do
    it 'should allow you to build a existing view without creating or appending it to the view tree' do
      my_view = SubviewTestView.alloc.initWithFrame(CGRectZero)
      test_view_wrapped = @vc.rmq.build(my_view)
      test_view = test_view_wrapped.get

      test_view.superview.nil?.should == true
      test_view.nextResponder.nil?.should == true
      test_view.get_context.should == test_view
    end

    it 'should allow you to build an existing view with a style, and it to use the stylesheet of view_controller that created it' do
      my_view = UILabel.alloc.initWithFrame(CGRectZero)
      @vc.rmq.stylesheet = StyleSheetForSubviewsTests
      test_view = @vc.rmq.build(my_view, :create_view_style).get
      test_view.backgroundColor.should == RubyMotionQuery::Color.blue
    end

    it 'should allow you to build a view outside any view tree, then append subviews and those should use the stylesheet from the rmq that created the parent view' do
      q = @vc.rmq
      q.stylesheet = StyleSheetForSubviewsTests
      my_view = SubviewTestView.alloc.initWithFrame(CGRectZero)
      test_view_wrapped = q.build(my_view)
      test_view = test_view_wrapped.get

      test_view_wrapped.parent_rmq.should == q

      test_view_wrapped.wrap(test_view).parent_rmq.parent_rmq.should == q

      sv = test_view.build_subview
      test_view_wrapped.children.first.get.should == sv
      test_view.subviews.first.should == sv

      test_view.build_subview.rmq_data.style_name.should == :create_sub_view_style
      test_view.build_subview.backgroundColor.should == RubyMotionQuery::Color.orange

      test_view.number_of_builds.should == 1
    end

    it 'has the ability to build!' do
      test = @vc.rmq.build!(UILabel)
      test.is_a?(UILabel).should == true
    end

    it 'should allow you to append a view, remove it, append it again, and only one rmq_build is called' do
      view = @vc.rmq.append!(SubviewTestView)
      view.number_of_builds.should == 1

      @vc.rmq.wrap(view).remove
      view.number_of_builds.should == 1

      @vc.rmq.append(view)
      view.number_of_builds.should == 1
    end

    it 'should allow you to create a view outside of RMQ, then append it with RMQ, the remove, then append, and only have rmq_build called once' do
      view = SubviewTestView.alloc.initWithFrame(CGRectZero)
      view.number_of_builds.should == nil

      @vc.rmq.append(view)
      view.number_of_builds.should == 1

      @vc.rmq.wrap(view).remove
      view.number_of_builds.should == 1

      @vc.rmq.append(view)
      view.number_of_builds.should == 1
    end

    it 'should build an existing view then yield to a block with the rmq wrapped view' do
      existing_view = UIView.new
      block_called = false
      @vc.rmq.build(existing_view) do |view|
        view.should.be.kind_of(RubyMotionQuery::RMQ)
        view.get.should == existing_view
        block_called = true
      end
      block_called.should == true
    end

    it 'should build an existing view then yield to a block with the existing view' do
      existing_view = UIView.new
      block_called = false
      @vc.rmq.build!(existing_view) do |view|
        view.should == existing_view
        block_called = true
      end
      block_called.should == true
    end
  end

  describe 'find_or_append' do
    it 'appends if none existing' do
      @vc.view.subviews.length.should == 0
      view = @vc.rmq.find_or_append(UIView).get
      @vc.view.subviews.length.should == 1
      @vc.view.subviews.first.should == view
    end

    it 'finds if existing' do
      @vc.rmq.stylesheet = StyleSheetForSubviewsTests
      @vc.view.subviews.length.should == 0
      existing_view = @vc.rmq.append(UIView, :my_style).get
      @vc.view.subviews.length.should == 1
      found_view = @vc.rmq.find_or_append(UIView, :my_style).get
      @vc.view.subviews.length.should == 1
      found_view.should == existing_view
    end
  end

  describe 'find_or_append!' do
    it 'appends if none existing' do
      @vc.view.subviews.length.should == 0
      view = @vc.rmq.find_or_append!(UIView)
      @vc.view.subviews.length.should == 1
      @vc.view.subviews.first.should == view
    end

    it 'finds if existing' do
      @vc.rmq.stylesheet = StyleSheetForSubviewsTests
      @vc.view.subviews.length.should == 0
      existing_view = @vc.rmq.append!(UIView, :my_style)
      @vc.view.subviews.length.should == 1
      found_view = @vc.rmq.find_or_append!(UIView, :my_style)
      @vc.view.subviews.length.should == 1
      found_view.should == existing_view
    end
  end
end

class StyleSheetForSubviewsTests < RubyMotionQuery::Stylesheet
  def my_style(st)
  end

  def create_view_style(st)
    st.background_color = color.blue
  end

  def create_sub_view_style(st)
    st.background_color = color.orange
  end
end

class SubviewTestView < UIView
  attr_accessor :subview, :build_subview, :number_of_builds

  def rmq_build
    if @number_of_builds
      @number_of_builds += 1
    else
      @number_of_builds = 1
    end

    @build_subview = rmq.append(UIView, :create_sub_view_style).get
  end

  def rmq_created
    @subview = rmq.append(UIView, :create_sub_view_style).get
  end

  def get_context
    rmq.context
  end
end

class SubTableTest < UITableView
end

class SubButtonTest < UIButton
end
