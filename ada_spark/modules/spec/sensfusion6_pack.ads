with Types; use Types;
with Interfaces.C.Extensions; use Interfaces.C.Extensions;
with IMU_Pack; use IMU_Pack;

package SensFusion6_Pack
with SPARK_Mode,
  Abstract_State => (SensFusion6_State),
  Initializes    => (SensFusion6_State)
is

   --  Procedures and functions

   procedure SensFusion6_Init;

   function SensFusion6_Test return bool;

   procedure SensFusion6_Update_Q
     (Gx : T_Rate;
      Gy : T_Rate;
      Gz : T_Rate;
      Ax : T_Acc;
      Ay : T_Acc;
      Az : T_Acc;
      Dt : T_Delta_Time);

   procedure SensFusion6_Get_Euler_RPY
     (Euler_Roll_Actual  : out T_Degrees;
      Euler_Pitch_Actual : out T_Degrees;
      Euler_Yaw_Actual   : out T_Degrees);


   function SensFusion6_Get_AccZ_Without_Gravity
     (Ax : T_Acc;
      Ay : T_Acc;
      Az : T_Acc) return Float;
private

   --  Global variables and constants

   Is_Init : bool := 0 with Part_Of => SensFusion6_State;

   Q0 : T_Quaternion := 1.0
     with Part_Of => SensFusion6_State;
   Q1 : T_Quaternion := 0.0
     with Part_Of => SensFusion6_State;
   Q2 : T_Quaternion := 0.0
     with Part_Of => SensFusion6_State;
   --  quaternion of sensor frame relative to auxiliary frame
   Q3 : T_Quaternion := 0.0
     with Part_Of => SensFusion6_State;

   pragma Export (C, Q0, "q0");
   pragma Export (C, Q1, "q1");
   pragma Export (C, Q2, "q2");
   pragma Export (C, Q3, "q3");

   --   Implementation of Madgwick's IMU and AHRS algorithms.
   --   See: http:--  www.x-io.co.uk/open-source-ahrs-with-x-imu
   --
   --   Date     Author          Notes
   --   29/09/2011 SOH Madgwick    Initial release
   --   02/10/2011 SOH Madgwick  Optimised for reduced CPU load

   --  Global variables and constants

   TWO_KP_DEF  : constant Float := (2.0 * 0.4);
   TWO_KI_DEF  : constant Float := (2.0 * 0.001);

   Two_Kp       : Float := TWO_KP_DEF
     with Part_Of => SensFusion6_State; --  2 * proportional gain (Kp)
   Two_Ki       : Float := TWO_KI_DEF
     with Part_Of => SensFusion6_State; --  2 * integral gain (Ki)

   --  Integral error terms scaled by Ki
   Integral_FBx : Float := 0.0
     with Part_Of => SensFusion6_State;
   Integral_FBy : Float := 0.0
     with Part_Of => SensFusion6_State;
   Integral_FBz : Float := 0.0
     with Part_Of => SensFusion6_State;

   --  Procedures and functions

   procedure Mahony_Update_Q
     (Gx : T_Rate;
      Gy : T_Rate;
      Gz : T_Rate;
      Ax : T_Acc;
      Ay : T_Acc;
      Az : T_Acc;
      Dt : T_Delta_Time);


end SensFusion6_Pack;
