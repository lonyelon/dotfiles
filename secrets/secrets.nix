let
  icebear = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA88vjWBHBQP5iGS0vr4SKhFFhuYKS7lFkTEJZUpy+7u";
  homeserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGSzjF1mXo/8ce5hsmnQmDjoEsufZ7jMYtQywxc4z5R5";
  nixremberg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOj2PCyWB4oXQECqleBcenvMDW5yNY+4sM5ICocpHoIx";
  rpi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFM/myUduu8AN2Xr63S4f5r1tymYd34/7MNe1oEkT1fW";
  nixpad = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII8MaNb7OPXFk2PL3m+34tqeq3pFcK1F5GQp2ZYBUvIQ";
  #nixtab
  #pixel8a
in
{
  "email.age".publicKeys                     = [ icebear nixpad                ];

  "email-server.age".publicKeys              = [ icebear            nixremberg ];

  "homeserver-docker.age".publicKeys         = [ icebear homeserver            ];

  "wg-private.pri.age".publicKeys            = [ icebear            nixremberg ];
  "wg-private.icebear.pre.age".publicKeys    = [ icebear            nixremberg ];
  "wg-private.icebear.pri.age".publicKeys    = [ icebear                       ];
  "wg-private.pixel8a.pre.age".publicKeys    = [ icebear            nixremberg ];
  "wg-private.pixel8a.pri.age".publicKeys    = [ icebear                       ];
  "wg-private.homeserver.pre.age".publicKeys = [ icebear homeserver nixremberg ];
  "wg-private.homeserver.pri.age".publicKeys = [ icebear homeserver            ];
  "wg-private.nixremberg.pre.age".publicKeys = [ icebear            nixremberg ];
  "wg-private.nixremberg.pri.age".publicKeys = [ icebear            nixremberg ];
  "wg-private.rpi.pre.age".publicKeys        = [ icebear rpi        nixremberg ];
  "wg-private.rpi.pri.age".publicKeys        = [ icebear rpi                   ];
  "wg-private.nixtab.pre.age".publicKeys     = [ icebear            nixremberg ];
  "wg-private.nixtab.pri.age".publicKeys     = [ icebear                       ];
  "wg-private.nixpad.pre.age".publicKeys     = [ icebear nixpad     nixremberg ];
  "wg-private.nixpad.pri.age".publicKeys     = [ icebear nixpad                ];

  "wg-public.pri.age".publicKeys             = [ icebear            nixremberg ];
  "wg-public.homeserver.pre.age".publicKeys  = [ icebear            nixremberg ];
  "wg-public.homeserver.pri.age".publicKeys  = [ icebear                       ];
  "wg-public.emma-iphone.pre.age".publicKeys = [ icebear            nixremberg ];
  "wg-public.emma-iphone.pri.age".publicKeys = [ icebear                       ];
  "wg-public.emma-pc.pre.age".publicKeys     = [ icebear            nixremberg ];
  "wg-public.emma-pc.pri.age".publicKeys     = [ icebear                       ];
  "wg-public.emma-ipad.pre.age".publicKeys   = [ icebear            nixremberg ];
  "wg-public.emma-ipad.pri.age".publicKeys   = [ icebear                       ];
}
