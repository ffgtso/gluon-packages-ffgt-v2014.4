## NOTE

This is a forked tree of Gluon's v2014.4 packages ...

It stems from a discussion on IRC:
```
00:43 < wusel> neoraider: "Du kannst keine Pakete im Site-Feed haben, die schon in Gluon existieren" also, eigentlich sollte das tun, faktisch ist das aber problematisch, ja.
00:43 <@neoraider> `make update` fasst nur base, patching und `patched` an
00:43 <@neoraider> wusel, das ist nicht vorgesehen und wird kaputtgehen
00:43 <@neoraider> OpenWrt unterstützt das nicht
00:44 <@neoraider> Da wird alles mögliche kaputtgehen, wenn OpenWrt Teile von beiden Paketdefinitionen verwendet...
00:44 <@neoraider> Also, OpenWrt unterstützt das durch ihr Feed-System für Pakete, die nicht im OpenWrt-Base sind, aber das nutzen wir für Gluon nicht
00:48 < wusel> neoraider: Äh. "PROVIDES:=gluon-setup-mode" sollte tun. Tut's nicht wirklich, aber das ist imho ein major fail.
00:48 <@neoraider> wusel, das sollte nicht tun
00:49 <@neoraider> Das ist nicht vorgesehen
00:49 <@neoraider> OpenWrt != Debian
00:49 <@neoraider> Unter OpenWrt funktioniert PROVIDES nicht so
00:49 <@neoraider> Das ist kein Bug, sondern ein fehlendes Feature
[...]
01:23 < wusel> neoraider: für mich stellt sich einfach die Frage "wie geht's weiter?".
01:23 <@neoraider> Grundsätzlich habt ihr 2 Möglichkeiten:
01:23 <@neoraider> 2014.4 anpassen oder warten auf 2015.1
01:24 <@neoraider> Letzteres wird wohl noch nen Monat dauern, oder mehr
01:24 <@neoraider> Ich hoffe, nicht deutlich mehr
01:24 <@neoraider> Wird mal wieder Zeit für ein Release
01:24 < wusel> neoraider: Aktuell "portiere" ich unsere Änderungen auf 2014.4. Mit PROVIDES, was nur nach Mondstand zu funzen scheint.
01:25 <@neoraider> Joa, wenn du PROVIDES für existierende Namen verwendest, explodieren die Makefiles, die OpenWrt da erzeugt, leider völlig
01:25 <@neoraider> Ich mache mal nen Ticket, dann werden ihr mit 2015.1 auf jeden Fall keinen Fork mehr brauchen
01:26 < wusel> Da der Weg augenscheinlich "deprecated" ist, werde ich das lassen. Andererseits brauche ich 2014.4 sschon wegen der neuen HW eher gestern :(
01:27 <@neoraider> Ich denke, das einfachste wäre, das ganze Paket-Repo zu forken und einfach eure Änderungen in das gluon-setup-mode-Paket reinzupacken
01:27 <@neoraider> Ist nicht sauber, aber da mit 2014.4 keine sauere Lösung möglich ist, ist wohl das wichtigste erstmal, eine funktionierende Lösung zu haben
```