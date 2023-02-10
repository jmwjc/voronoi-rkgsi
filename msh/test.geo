
a = 1.0;
n = 20;
c = a/n;

Point(1) = {0.0, 0.0, 0.0, c};
Point(2) = {  a, 0.0, 0.0, c};
Point(3) = {  a,   a, 0.0, c};
Point(4) = {0.0,   a, 0.0, c};

Line(1) = {1,2};
Line(2) = {2,3};
Line(3) = {3,4};
Line(4) = {4,1};

Curve Loop(1) = {1,2,3,4};

Plane Surface(1) = {1};

Physical Curve("Γᵍ") = {1,2,3,4};
// Physical Curve("Γᵗ") = {3,4};
Physical Surface("Ω") = {1};

// Mesh.CharacteristicLength = c;
Mesh.Algorithm = 6;
Mesh.MshFileVersion = 2;
Mesh 2;