within PlanarMechanics.Visualizers.Advanced;
model CoordinateSystem
  "Visualizing an orthogonal coordinate system of three axes"

  input SI.Position r[3]={0,0,0}
    "Position vector from origin of world frame to origin of object frame, resolved in world frame"
    annotation(Dialog);
  input MB.Frames.Orientation R=MB.Frames.nullRotation()
    "Orientation object to rotate the world frame into the object frame"  annotation(Dialog);
  input SI.Position r_shape[3]={0,0,0}
    "Position vector from origin of object frame to shape origin, resolved in object frame"
    annotation(Dialog);

  parameter SI.Length axisLength=planarWorld.nominalLength/2
    "Length of world axes arrows";
  parameter SI.Diameter axisDiameter=axisLength/planarWorld.defaultFrameDiameterFraction
    "Diameter of world axes arrows";

  parameter PlanarMechanics.Types.Color color_x=PlanarMechanics.Types.Defaults.FrameColor
    "Color of x-arrow"
    annotation (HideResult = true, Dialog(colorSelector=true));
  parameter PlanarMechanics.Types.Color color_y=color_x "Color of y-arrow"
    annotation (HideResult = true, Dialog(colorSelector=true));
  parameter PlanarMechanics.Types.Color color_z=color_x "Color of z-arrow"
    annotation (HideResult = true, Dialog(colorSelector=true));

  parameter Boolean axisShowLabels=true "True, if labels shall be shown"
    annotation (HideResult=true, Dialog(group="Axes labels"));
  parameter SI.Length labelStart=1.05*axisLength
    annotation(Dialog(group="Axes labels", enable=axisShowLabels));
  parameter SI.Length scaledLabel=PlanarMechanics.Types.Defaults.FrameLabelHeightFraction*axisDiameter
    annotation(Dialog(group="Axes labels", enable=axisShowLabels));

protected
  outer .PlanarMechanics.PlanarWorld planarWorld;
  Internal.CoordinateSystem coordinateSystem(
    final r=r,
    final R=R,
    final r_shape=r_shape,
    final axisLength=axisLength,
    final axisDiameter=axisDiameter,
    final color_x=color_x,
    final color_y=color_y,
    final color_z=color_z,
    final axisShowLabels=axisShowLabels,
    final labelStart=labelStart,
    final scaledLabel=scaledLabel) if planarWorld.enableAnimation;
  annotation (Documentation(info="<html>
<p>
This element enbles visualization of an <b>orthogonal coordinate system</b>
as shown in the following picture.
</p>

<p>
<img src=\"modelica://PlanarMechanics/Resources/Images/Visualizers/Advanced/CoordinateSystem.png\" ALT=\"model Visualizers.Advanced.CoordinateSystem\">
</p>

<p>
The variables <code>r</code>, <code>R</code> and <code>r_shape</code>
are declared as (time varying) <b>input</b> variables.
If the default equation is not appropriate, a corresponding
modifier equation has to be provided in the
model where a <b>CoordinateSystem</b> instance is used, e.g., in the form
</p>
<blockquote><pre>
PlanarMechanics.Visualizers.Advanced.CoordinateSystem coordinateSystem(r = {sin(time), 0, 0.3});
</pre></blockquote>

<p>
<b>Color</b> of each axis can be set individually using RGB color space given in the range 0 .. 255.
The predefined type <a href=\"modelica://PlanarMechanics.Types.Color\">Types.Color</a>
contains a menu definition of the colors used in the library</a>
(will be replaced by a color editor).
</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-150,100},{150,60}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-50,-90},{0,-72},{50,-90},{90,-70},{26,-16},{8,40},{-8,40},{-28,
              -16},{-90,-70},{-50,-90}},
          lineColor={255,255,255},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,-30},{0,40}},
          color={135,135,135},
          thickness=0.5),
        Line(
          points={{0,-30},{74,-66}},
          color={135,135,135},
          thickness=0.5),
        Line(
          points={{-70,-66},{0,-30}},
          thickness=0.5,
          color={135,135,135}),
        Text(
          extent={{-69,-54},{-20,-84}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="x"),
        Polygon(
          points={{-96,-80},{-64,-72},{-76,-58},{-96,-80}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{100,-82},{76,-56},{66,-72},{100,-82}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{25,-54},{74,-84}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="z"),
        Text(
          extent={{10,60},{61,30}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Polygon(
          points={{-14,22},{14,22},{0,62},{-14,22}},
          lineColor={135,135,135},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid)}));
end CoordinateSystem;
