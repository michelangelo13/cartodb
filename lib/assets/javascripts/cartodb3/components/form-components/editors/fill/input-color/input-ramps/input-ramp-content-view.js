var Backbone = require('backbone');
var _ = require('underscore');
var CoreView = require('backbone/core-view');
var InputRampListView = require('./input-ramp-list-view');
var StackLayoutView = require('../../../../../../components/stack-layout/stack-layout-view');
var InputColorPickerView = require('../input-color-picker/input-color-picker-view');

module.exports = CoreView.extend({
  events: {
    'click .js-back': '_onClickBack'
  },

  initialize: function (opts) {
    this._initViews();
  },

  render: function () {
    this.clearSubViews();
    this.$el.empty();

    this.$el.append(this._stackLayoutView.render().$el);

    return this;
  },

  _initViews: function () {
    var self = this;

    var stackViewCollection = new Backbone.Collection([{
      createStackView: function (stackLayoutModel, opts) {
        return self._createInputRampListView(stackLayoutModel, opts).bind(self);
      }
    }, {
      createStackView: function (stackLayoutModel, opts) {
        return self._createColorPickerView(stackLayoutModel, opts).bind(self);
      }
    }]);

    this._stackLayoutView = new StackLayoutView({
      collection: stackViewCollection
    });
  },

  _createColorPickerView: function (stackLayoutModel, opts) {
    var range = _.map(this.model.get('range'), function (color, i) {
      return {
        val: color,
        color: color,
        title: this.model.get('attribute')
      };
    }, this);

    var view = new InputColorPickerView({
      index: 0,
      ramp: range
    });

    view.bind('back', function (value) {
      stackLayoutModel.prevStep();
    }, this);

    view.bind('change', this._updateRange, this);

    return view;
  },

  _createInputRampListView: function (stackLayoutModel, opts) {
    var view = new InputRampListView({
      model: this.model,
      showSearch: this.options.showSearch || false,
      typeLabel: this.options.typeLabel
    });

    view.bind('customize', function (value) {
      stackLayoutModel.nextStep();
    }, this);

    view.bind('change_ramp', this._updateRamp, this);
    view.bind('change', this._updateRange, this);

    view.bind('back', function (value) {
      this.trigger('back', this);
    }, this);

    view.bind('switch', function (value) {
      this.trigger('switch', this);
    }, this);

    view.bind('selectItem', function (item) {
      this.trigger('selectItem', item.get('val'), this);
    }, this);

    view.bind('selectBins', function (item) {
      this.trigger('selectBins', this);
    }, this);

    view.bind('selectQuantification', function (item) {
      this.trigger('selectQuantification', this);
    }, this);

    return view;
  },

  _updateRamp: function (ramp) {
    this.model.set('range', ramp);
  },

  _updateRange: function (categories) {
    this.model.set('range', _.pluck(categories, 'color'));
  },

  _onClickBack: function (e) {
    this.killEvent(e);
    this.trigger('back', this);
  }
});

