within PlanarMechanics.Interfaces;
model PlanarTo3D "This model enables to connect planar models to the 3-dimensional world"
  parameter SI.Length zPosition = planarWorld.defaultZPosition
    "Position z of cylinder representing the fixed translation";
    //annotation (Dialog(tab="Animation", group="if animation = true", enable=animate));

  outer PlanarWorld planarWorld "planar world model";
  Frame_b framePlanar "Frame connector in PlanarMechanics"
    annotation (Placement(transformation(extent={{44,-16},{76,16}}), iconTransformation(extent={{44,-16},{76,16}})));
  MB.Interfaces.Frame_a frameMultiBody "Frame connector in MultiBody"
    annotation (Placement(transformation(extent={{-76,-16},{-44,16}}), iconTransformation(extent={{-76,-16},{-44,16}})));

protected
  constant SI.Force fz = 0 "Force normal to 2D plane";
  constant SI.Torque tx = 0 "Torque about x-axis of 2D plane";
  constant SI.Torque ty = 0 "Torque about y-axis of 2D plane";
  SI.Force f0[3] "Force vector resolved w.r.t inertial frame";
  SI.Torque t0[3] "Torque vector resolved w.r.t inertial frame";
  Real angles[3](stateSelect=StateSelect.always) "Actual orientation angles of frameMultiBody";
  Real position[3] "Actual position of frameMultiBody";

initial equation
  angles = MB.Frames.axesRotationsAngles(frameMultiBody.R, {1,2,3}, 0);

equation
  // The following assert is not needed since rooting of the connection is treated here
  //assert(cardinality(frameMultiBody) > 0,
  //  "Connector frameMultiBody of " + getInstanceName() + " is not connected");
  assert(cardinality(framePlanar) > 0,
    "Connector framePlanar of " + getInstanceName() + " is not connected");

  Connections.potentialRoot(frameMultiBody.R,1);

  if Connections.isRoot(frameMultiBody.R) then
    // This element is 'root'
    frameMultiBody.r_0 = zeros(3);
    frameMultiBody.R = MB.Frames.nullRotation();
    f0 = zeros(3);
    t0 = zeros(3);
  else
    // Define force and torque vectors in inertial system
    f0 = MB.Frames.resolve1(frameMultiBody.R, frameMultiBody.f);
    t0 = MB.Frames.resolve1(frameMultiBody.R, frameMultiBody.t);

    // Force and torque balance
    MB.Frames.resolve2(planarWorld.R, f0) + {framePlanar.fx, framePlanar.fy, fz} = zeros(3);
    MB.Frames.resolve2(planarWorld.R, t0) + {tx, ty, framePlanar.t} = zeros(3);
  end if;

  //Express 3D-rotation as planar rotation around z-axes
  //        The planarWorld.r_0 subtraction is not done here since it has influence on
  //        the (false) visualization of planar mechanics in 3D world
  position = MB.Frames.resolve2(planarWorld.R, frameMultiBody.r_0); // - planarWorld.r_0;

  framePlanar.x = position[1];
  framePlanar.y = position[2];
  framePlanar.phi = angles[3];
  der(angles) = frameMultiBody.R.w;

  annotation (
    defaultComponentName="adaptor3D",
    Icon(
      coordinateSystem(extent={{-60,-60},{60,60}}, initialScale=0.1),
      graphics={
        Rectangle(
          extent={{-56,22},{2,-22}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.HorizontalCylinder),
        Text(
          extent={{-90,60},{90,30}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-4,24},{6,24},{6,18},{-10,18},{-4,24}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-8,-18},{4,-18},{4,-24},{-14,-24},{-8,-18}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,-18},{20,18},{-10,18},{-18,10},{0,-10},{-8,-18},{20,-18}},
          lineColor={255,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,0,0}),
        Polygon(
          points={{56,-22},{4,-22},{16,-10},{-2,10},{10,22},{56,22},{56,-22}},
          lineColor={0,0,0},
          fillColor={225,240,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-6,22},{-18,10},{0,-10},{-12,-22}}, color={0,0,0})}),
    Documentation(
      revisions="<html>
<p>
<img src=\"modelica://PlanarMechanics/Resources/Images/dlr_logo.png\" alt=\"DLR logo\">
<b>Developed 2018 at the DLR Institute of System Dynamics and Control</b>
</p>
</html>",
      info="<html>
<p>This component enables the connection between planar and <a href=\"Modelica://Modelica.Mechanics.MultiBody\">3-dimensional</a> mechanics.</p>
<p>The orientation and position of the 2D system within the 3D system are determined by the Multi-Body connector of the planar world model or zero rotation at zero position otherwise</p>
<p>The physical connection assumes the 2D world to be the root of the system, defining the orientation. All forces and torques acting outside the plane are assumed to be absorbed by the planar world system.. Beware! These forces are not transmitted by the Multi-Body connector of the planar world.</p>
<p>See also <a href=\"modelica://PlanarMechanics.UsersGuide.Tutorial.Connecting3D\">Tutorial</a> for more information.</p>
</html>"),
    Diagram(coordinateSystem(extent={{-60,-60},{60,60}}, initialScale=0.1),
        graphics={Line(
          points={{-60,0},{60,0}},
          color={95,95,95},
          thickness=0.5)}));
end PlanarTo3D;
