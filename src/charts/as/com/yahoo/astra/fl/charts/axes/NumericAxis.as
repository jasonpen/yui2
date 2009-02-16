package com.yahoo.astra.fl.charts.axes
{
	import com.yahoo.astra.fl.charts.series.ISeries;
	import com.yahoo.astra.fl.utils.UIComponentUtil;
	import com.yahoo.astra.utils.NumberUtil;
	import com.yahoo.astra.fl.charts.CartesianChart;	
	
	import flash.utils.Dictionary;
	import fl.core.UIComponent;
	
	/**
	 * An axis type representing a numeric range from minimum to maximum
	 * with major and minor divisions.
	 * 
	 * @author Josh Tynjala
	 */
	public class NumericAxis extends BaseAxis implements IAxis, IOriginAxis, IStackingAxis
	{
		
	//--------------------------------------
	//  Constructor
	//--------------------------------------
	
		/**
		 * Constructor.
		 */
		public function NumericAxis()
		{
		}

	//--------------------------------------
	//  Properties
	//--------------------------------------
		
		/**
		 * @private
		 * The multiplier used to calculate the position on the renderer from an
		 * axis value.
		 */
		protected var positionMultiplier:Number = 0;
		
		/**
		 * @private
		 * Storage for the minimum value.
		 */
		private var _minimum:Number = 0;
		
		/**
		 * @private
		 * Indicates whether the minimum bound is user-defined or generated by the axis.
		 */
		private var _minimumSetByUser:Boolean = false;
		
		/**
		 * The minimum value displayed on the axis. By default, this value is generated
		 * by the axis itself. If the user defines this value, the axis will skip this
		 * automatic generation. To enable this behavior again, set this property to NaN.
		 */
		public function get minimum():Number
		{
			return this._minimum;
		}
		
		/**
		 * @private
		 */
		public function set minimum(value:Number):void
		{
			this._minimum = value;
			this._minimumSetByUser = !isNaN(value);
		}
	
		/**
		 * @private
		 * Storage for the maximum value.
		 */
		private var _maximum:Number = 100;
		
		/**
		 * @private
		 * Indicates whether the maximum bound is user-defined or generated by the axis.
		 */
		private var _maximumSetByUser:Boolean = false;
		
		/**
		 * The maximum value displayed on the axis. By default, this value is generated
		 * by the axis itself. If the user defines this value, the axis will skip this
		 * automatic generation. To enable this behavior again, set this property to NaN.
		 */
		public function get maximum():Number
		{
			return this._maximum;
		}
		
		/**
		 * @private
		 */
		public function set maximum(value:Number):void
		{
			this._maximum = value;
			this._maximumSetByUser = !isNaN(value);
		}
		
	//-- Units
	
		/**
		 * @private
		 * Storage for the major unit.
		 */
		private var _majorUnit:Number = 10;
		
		/**
		 * @private
		 * Indicates whether the major unit is user-defined or generated by the axis.
		 */
		private var _majorUnitSetByUser:Boolean = false;
		
		/**
		 * The major unit at which new ticks and labels are drawn. By default, this value
		 * is generated by the axis itself. If the user defines this value, the axis will
		 * skip the automatic generation. To enable this behavior again, set this property
		 * to NaN.
		 */
		public function get majorUnit():Number
		{
			return this._majorUnit;
		}
		
		/**
		 * @private
		 */
		public function set majorUnit(value:Number):void
		{
			this._majorUnit = value;
			this._majorUnitSetByUser = !isNaN(value);
		}
	
		/**
		 * @private
		 * Storage for the minor unit.
		 */
		private var _minorUnit:Number = 0;
		
		/**
		 * @private
		 * Indicates whether the minor unit is user-defined or generated by the axis.
		 */
		private var _minorUnitSetByUser:Boolean = false;
		
		/**
		 * The minor unit at which new ticks are drawn. By default, this value
		 * is generated by the axis itself. If the user defines this value, the axis will
		 * skip the automatic generation. To enable this behavior again, set this property
		 * to NaN.
		 */
		public function get minorUnit():Number
		{
			return this._minorUnit;
		}
		
		/**
		 * @private
		 */
		public function set minorUnit(value:Number):void
		{
			this._minorUnit = value;
			this._minorUnitSetByUser = !isNaN(value);
		}
		
		/**
		 * @inheritDoc
		 */
		public function get origin():Object
		{
			var origin:Number = 0;
			if(this.scale == ScaleType.LOGARITHMIC)
			{
				origin = 1;
			}
			
			origin = Math.max(origin, this.minimum);
			origin = Math.min(origin, this.maximum);
			return origin;
		}
		
		/**
		 * @private
		 * Storage for the stackingEnabled property.
		 */
		private var _stackingEnabled:Boolean = false;
		
		/**
		 * @inheritDoc
		 */
		public function get stackingEnabled():Boolean
		{
			return this._stackingEnabled;
		}
		
		/**
		 * @private
		 */
		public function set stackingEnabled(value:Boolean):void
		{
			this._stackingEnabled = value;
		}
	
		/**
		 * @private
		 * Storage for the alwaysShowZero property.
		 */
		private var _alwaysShowZero:Boolean = true;
		
		/**
		 * If true, the axis will attempt to keep zero visible at all times.
		 * If both the minimum and maximum values displayed on the axis are
		 * above zero, the minimum will be reset to zero. If both minimum and
		 * maximum appear below zero, the maximum will be reset to zero. If
		 * the minimum and maximum appear at positive and negative values
		 * respectively, zero is already visible and the axis scale does not
		 * change.
		 * 
		 * <p>This property has no affect if you manually set the minimum and
		 * maximum values of the axis.</p>
		 */
		public function get alwaysShowZero():Boolean
		{
			return this._alwaysShowZero;
		}
		
		/**
		 * @private
		 */
		public function set alwaysShowZero(value:Boolean):void
		{
			this._alwaysShowZero = value;
		}
	
		/**
		 * @private
		 * Storage for the snapToUnits property.
		 */
		private var _snapToUnits:Boolean = true;
		
		/**
		 * If true, the labels, ticks, gridlines, and other objects will snap to
		 * the nearest major or minor unit. If false, their position will be based
		 * on the minimum value.
		 */
		public function get snapToUnits():Boolean
		{
			return this._snapToUnits;
		}
		
		/**
		 * @private
		 */
		public function set snapToUnits(value:Boolean):void
		{
			this._snapToUnits = value;
		}
		
		/**
		 * @private
		 * Storage for the scale property.
		 */
		private var _scale:String = ScaleType.LINEAR;
		
		/**
		 * The type of scaling used to display items on the axis.
		 * 
		 * @see com.yahoo.astra.fl.charts.ScaleType
		 */
		public function get scale():String
		{
			return this._scale;
		}
		
		/**
		 * @private
		 */
		public function set scale(value:String):void
		{
			this._scale = value;
		}
		
		/**
		 * @private
		 */
		private var _dataMinimum:Number = NaN;
		
		/**
		 * @private
		 */
		private var _dataMaximum:Number = NaN;
		
		/**
		 * @private
		 */
		private var _numLabels:Number;
		
		/**
		 * @private
		 */		
		private var _numLabelsSetByUser:Boolean = false;

		/**
		 * @inheritDoc
		 */
		public function get numLabels():Number
		{
			return _numLabels;
		}
		
		/**
		 * @private (setter)
		 */
		public function set numLabels(value:Number):void
		{
			if(_numLabelsSetByUser) return;
			_numLabels = value;
			_numLabelsSetByUser = true;
			_majorUnitSetByUser = false;
			_minorUnitSetByUser = false;
		}		
			
		/**
		 * @private 
		 */
		private var _roundMajorUnit:Boolean = true;
		
		/**
		 * Indicates whether to round the major unit
		 */
		public function get roundMajorUnit():Boolean
		{
			return _roundMajorUnit;
		}
		
		/**
		 * @private (setter)
		 */
		public function set roundMajorUnit(value:Boolean):void
		{
			_roundMajorUnit = value;
		}
		
	//--------------------------------------
	//  Public Methods
	//--------------------------------------
	
		/**
		 * @inheritDoc
		 */
		public function valueToLocal(data:Object):Number
		{
			if(data == null)
			{
				//bad data. a properly-designed renderer will not draw this.
				return NaN;
			}
			
			var position:Number = 0;
			
			if(this.scale == ScaleType.LINEAR)
			{
				position = (Number(data) - this.minimum) * this.positionMultiplier;
			}
			else
			{
				var logOfData:Number = Math.log(Number(data));
				var logOfMinimum:Number = Math.log(this.minimum);
				position = (logOfData - logOfMinimum) * this.positionMultiplier;
			}
			
			if(this.reverse)
			{
				position = this.renderer.length - position;
			}
			
			//the vertical axis has its origin on the bottom
			if(this.renderer is ICartesianAxisRenderer && ICartesianAxisRenderer(this.renderer).orientation == AxisOrientation.VERTICAL)
			{
				position = this.renderer.length - position;
			}
			
			return Math.round(position);
		}
	
		/**
		 * @inheritDoc
		 */
		public function stack(top:Object, ...rest:Array):Object
		{
			var numericValue:Number = Number(top);
			var negative:Boolean = false;
			if(numericValue < 0)
			{
				negative = true;
			}
			
			var restCount:int = rest.length;
			for(var i:int = 0; i < restCount; i++)
			{
				var currentValue:Number = Number(rest[i]);
				if(negative && currentValue < 0)
				{
					numericValue += currentValue;
				}
				else if(!negative && currentValue > 0)
				{
					numericValue += currentValue;
				}
			}
			return numericValue;
		}
			
		/**
		 * @inheritDoc
		 */
		public function updateScale():void
		{			
			this.resetScale();
			this.calculatePositionMultiplier();
			
			(this.renderer as ICartesianAxisRenderer).majorUnitSetByUser = this._majorUnitSetByUser;
			this.renderer.ticks = this.createAxisData(this.majorUnit);
			this.renderer.minorTicks = this.createAxisData(this.minorUnit);
		}

		/**
		 * @inheritDoc
		 */
		public function getMaxLabel():String
		{
			var difference:Number = Math.round(this.maximum - this.minimum);
			var maxString:String = this.valueToLabel(this.maximum);
			var minString:String = this.valueToLabel(this.minimum);
			var halfString:String = this.valueToLabel(Math.round(difference/2));
			var thirdString:String = this.valueToLabel(Math.round(difference/3));
			if(maxString.length < minString.length) maxString = minString;
			if(halfString.length > maxString.length) maxString = halfString;
			if(thirdString.length > maxString.length) maxString = thirdString;
			return maxString as String;	
		}
		
	//--------------------------------------
	//  Protected Methods
	//--------------------------------------
	
		/**
		 * @private
		 * If the minimum, maximum, major unit or minor unit have not been set by the user,
		 * these values must be generated by the axis. May be overridden to use custom
		 * scaling algorithms.
		 */
		protected function resetScale():void
		{	
			//use the discovered min and max from the data
			//if the developer didn't specify anything
			if(!this._minimumSetByUser)
			{
				this._minimum = this._dataMinimum;
			}
			if(!this._maximumSetByUser)
			{
				this._maximum = this._dataMaximum;
			}
			
			this.checkMinLessThanMax();
			
			this.pinToOrigin();
			
			this.calculateMajorUnit();
			this.adjustMinAndMaxFromMajorUnit();
				
			this.correctLogScaleMinimum();
			
			//ensure that min != max
			if(!this._maximumSetByUser && this._minimum == this._maximum)
			{
				this._maximum = this._minimum + 1;
				if(!this._majorUnitSetByUser)
				{
					//rarely happens, so I'll hardcode a nice major unit
					//for our difference of one
					this._majorUnit = 0.5;
				}
			}
			
			this.calculateMinorUnit();
			
			//even if they are manually set by the user, check all values for possible floating point errors.
			//we don't want extra labels or anything like that!
			this._minimum = NumberUtil.roundToPrecision(this._minimum, 10);
			this._maximum = NumberUtil.roundToPrecision(this._maximum, 10);
			this._majorUnit = NumberUtil.roundToPrecision(this._majorUnit, 10);
			this._minorUnit = NumberUtil.roundToPrecision(this._minorUnit, 10);
		}

		/**
		 * @private
		 * Determines the best major unit.
		 */
		protected function calculateMajorUnit():void
		{
			if(this._majorUnitSetByUser)
			{
				return;
			}
			
			var approxLabelDistance:Number;
			//Check to see if this axis is horizontal. Since the width of labels will be variable, we will need to apply a different alogrithm to determine the majorUnit.
			if((this.chart as CartesianChart).horizontalAxis == this)
			{
				//extract the approximate width of the labels by getting the textWidth of the maximum date when rendered by the label function with the textFormat of the renderer.
				approxLabelDistance = this.maxLabelWidth;			
			}
			else
			{
				approxLabelDistance = this.maxLabelHeight;	
			}
			var labelSpacing:Number = this.labelSpacing; 
			approxLabelDistance += (labelSpacing*2);
			
			var difference:Number = Math.round(Math.abs(this.minimum -  this.maximum));
			var tempMajorUnit:Number = 0; 

			var maxLabels:Number = Math.floor((this.renderer.length - labelSpacing)/approxLabelDistance);
			
			//Adjust the max labels to account for potential maximum and minimum adjustments that may occur.
			if(!this._maximumSetByUser && !this._minimumSetByUser && !(this.alwaysShowZero && this._minimum == 0)) maxLabels -= 1;
			
			//If set by user, use specified number of labels unless its too many
			if(this._numLabelsSetByUser)
			{
				maxLabels = Math.min(maxLabels, this.numLabels);
			}

			tempMajorUnit = difference/maxLabels;
			if(tempMajorUnit > 1) tempMajorUnit = Math.ceil(tempMajorUnit);
			tempMajorUnit = Math.min(tempMajorUnit, Math.round(difference/2));			
			
			if(this.roundMajorUnit)
			{
				var order:Number = Math.ceil(Math.log(tempMajorUnit) * Math.LOG10E);
				var roundedMajorUnit:Number = Math.pow(10, order);

				if (roundedMajorUnit / 2 >= tempMajorUnit) 
				{
					var roundedDiff:Number = Math.floor((roundedMajorUnit / 2 - tempMajorUnit) / (Math.pow(10,order-1)/2));
				 	tempMajorUnit = roundedMajorUnit/2 - roundedDiff*Math.pow(10,order-1)/2;
				}
				else 
				{
					tempMajorUnit = roundedMajorUnit;
				}
			}
	
			this._majorUnit = tempMajorUnit;									
		}

		/**
		 * @private
		 * Determines the best minor unit.
		 */
		protected function calculateMinorUnit():void
		{
			if(this._minorUnitSetByUser)
			{
				return;
			}
			
			var range:Number = this.maximum - this.minimum;
			var majorUnitSpacing:Number = this.renderer.length * (this.majorUnit / range);

			if(this._majorUnit != 1)
			{
				if(this._majorUnit % 2 == 0)
				{
					this._minorUnit = this._majorUnit / 2;
				}
				else if(this._majorUnit % 3 == 0)
				{
					this._minorUnit = this._majorUnit / 3;
				}
				else this._minorUnit = 0;
			}
		}
		
		/**
		 * @private
		 * Creates the AxisData objects for the axis renderer.
		 */
		protected function createAxisData(unit:Number):Array
		{
			if(unit <= 0)
			{
				return [];
			}
			
			var data:Array = [];
			var displayedMaximum:Boolean = false;
			var value:Number = this.minimum;
			while(value <= this.maximum)
			{
				value = NumberUtil.roundToPrecision(value, 10);
				
				//because Flash UIComponents round the position to the nearest pixel, we need to do the same.
				var position:Number = Math.round(this.valueToLocal(value));
				var label:String = this.valueToLabel(value);
				var axisData:AxisData = new AxisData(position, value, label);
				data.push(axisData);
				
				//if the maximum has been displayed, we're done!
				if(displayedMaximum) break;
				
				//a bad unit will get us stuck in an infinite loop
				if(unit <= 0)
				{
					value = this.maximum;
				}
				else
				{
					value += unit;
					if(this.snapToUnits && !this._minimumSetByUser && this.alwaysShowZero)
					{
						value = NumberUtil.roundDownToNearest(value, unit);
					}
					if(this._majorUnitSetByUser) value = Math.min(value, this.maximum);
				}
				displayedMaximum = NumberUtil.fuzzyEquals(value, this.maximum);
			}
			return data;
		}
		
	//--------------------------------------
	//  Private Methods
	//--------------------------------------
	
		/**
		 * @private
		 * If we want to always show zero, corrects the min or max as needed.
		 */
		private function pinToOrigin():void
		{
			//if we're pinned to zero, and min or max is supposed to be generated,
			//make sure zero is somewhere in the range
			if(this.alwaysShowZero)
			{
				if(!this._minimumSetByUser && this._minimum > 0 && this._maximum > 0)
				{
					this._minimum = 0;
				}
				else if(!this._maximumSetByUser && this._minimum < 0 && this._maximum < 0)
				{
					this._maximum = 0;
				}
			}
		}
		
		/**
		 * @private
		 * Increases the maximum and decreases the minimum based on the major unit.
		 */
		private function adjustMinAndMaxFromMajorUnit():void
		{
			//adjust the maximum so that it appears on a major unit
			//but don't change the maximum if the user set it or it is pinned to zero
			if(!this._maximumSetByUser && !(this.alwaysShowZero && this._maximum == 0))
			{
				var oldMaximum:Number = this._maximum;
				if(this._minimumSetByUser)
				{	
					//if the user sets the minimum, we need to ensure that the maximum is an increment of the major unit starting from 
					//the minimum instead of zero
					this._maximum = NumberUtil.roundUpToNearest(this._maximum - this._minimum, this._majorUnit);
					this._maximum += this._minimum;
				}
				else
				{
					this._maximum = NumberUtil.roundUpToNearest(this._maximum, this._majorUnit);
				}
				
				//uncomment to include an additional major unit in this adjustment
				if(this._maximum == oldMaximum /*|| this._maximum - oldMaximum < this._majorUnit */)
				{
					this._maximum += this._majorUnit;
				}
			}
			
			//adjust the minimum so that it appears on a major unit
			//but don't change the minimum if the user set it or it is pinned to zero
			if(!this._minimumSetByUser && !(this.alwaysShowZero && this._minimum == 0))
			{
				var oldMinimum:Number = this._minimum;
				this._minimum = NumberUtil.roundDownToNearest(this._minimum, this._majorUnit);
				
				//uncomment to include an additional major unit in this adjustment
				if(this._minimum == oldMinimum /*|| oldMinimum - this._minimum < this._majorUnit*/)
				{
					this._minimum -= this._majorUnit;
				}
			}
		}
		
		/**
		 * @private
		 * If we're using logarithmic scale, corrects the minimum if it gets set
		 * to a value <= 0.
		 */
		private function correctLogScaleMinimum():void
		{
			//logarithmic scale can't have a minimum value <= 0. If that's the case, push it up to 1.0
			//TODO: Determine if there's a better way to handle this...
			if(!this._minimumSetByUser && this.scale == ScaleType.LOGARITHMIC && this._minimum <= 0)
			{
				//use the dataMinimum if it's between 0 and 1
				//otherwise, just use 1
				if(this._dataMinimum > 0 && this._dataMinimum < 1)
				{
					this._minimum = this._dataMinimum;
				}
				else
				{
					this._minimum = 1;
				}
			}
		}

		/**
		 * @private
		 * Calculates a "nice" number for use with major or minor units
		 * on the axis. Only returns numbers similar to 10, 20, 25, and 50.
		 */
		private function niceNumber(value:Number):Number
		{
			if(value == 0)
			{
				return 0;
			}
			
			var count:int = 0;
			while(value > 10.0e-8)
			{
				value /= 10;
				count++;
			}

			//all that division in the while loop up there
			//could cause rounding errors. Don't you hate that?
			value = NumberUtil.roundToPrecision(value, 10);

		    if(value > 4.0e-8)
		    {
		        value = 5.0e-8;
		    }
		    else if(value > 2.0e-8)
		    {
		        value = 2.5e-8;
		    }
		    else if(value > 1.0e-8)
		    {
		        value = 2.0e-8;
		    }
		    else
		    {
		        value = 1.0e-8;
		    }
					
		    for(var i:int = count; i > 0; i--)
		    {
		    	value *= 10;
		    }
		
		    return value;
		}
		
		/**
		 * @private
		 * Swaps the minimum and maximum values, if needed.
		 */
		private function checkMinLessThanMax():void
		{
			if(this._minimum > this._maximum)
			{
				var temp:Number = this._minimum;
				this._minimum = this._maximum;
				this._maximum = temp;
				
				//be sure to swap these flags too!
				var temp2:Boolean = this._minimumSetByUser;
				this._minimumSetByUser = this._maximumSetByUser;
				this._maximumSetByUser = temp2;
			}
		}
	
		/**
		 * @private
		 * Calculates the multiplier used to convert a data point to an actual position
		 * on the axis.
		 */
		private function calculatePositionMultiplier():void
		{
			var range:Number = this.maximum - this.minimum;
			if(this.scale == ScaleType.LOGARITHMIC)
			{
				range = Math.log(this.maximum) - Math.log(this.minimum);
			}
			
			if(range == 0)
			{
				this.positionMultiplier = 0;
				return;
			}			
			this.positionMultiplier = this.renderer.length / range;
		}
		/**
		 * @private
		 */
		override protected function parseDataProvider():void
		{
			var seriesCount:int = this.dataProvider.length;
			var dataMinimum:Number = NaN;
			var dataMaximum:Number = NaN;
			for(var i:int = 0; i < seriesCount; i++)
			{
				var series:ISeries = this.dataProvider[i] as ISeries;
				var seriesLength:int = series.length;
				for(var j:int = 0; j < seriesLength; j++)
				{
					var item:Object = series.dataProvider[j];
					if(item === null)
					{
						continue;
					}
					
					//automatically calculates stacked values
					var value:Number = this.chart.itemToAxisValue(series, j, this) as Number;
					if(isNaN(value))
					{
						continue; //skip bad data
					}
					
					//don't let bad data propogate
					//Math.min()/Math.max() with a NaN argument will choose NaN. Ya Rly.
					dataMinimum = isNaN(dataMinimum) ? value : Math.min(dataMinimum, value);
					dataMaximum = isNaN(dataMaximum) ? value : Math.max(dataMaximum, value);
				}
			}
			
			if(!isNaN(dataMinimum) && !isNaN(dataMaximum))
			{
				this._dataMinimum = dataMinimum;
				this._dataMaximum = dataMaximum;
			}
			else
			{
				//some sensible defaults
				this._dataMinimum = 0;
				this._dataMaximum = 1;
			}									
		}		
	}
}