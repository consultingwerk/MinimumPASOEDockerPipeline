docker run -it --name pug-pasoe_%1 ^
-p 22000:8820 -p 22001:8821 -p 22003:8822 -p 22005:8823 ^
-v C:\PUG_USA2023\src\Pasoe\License\progress.cfg:/psc/dlc/progress.cfg ^
pug-pasoe:%1

docker container rm -f pug-pasoe_%1 
