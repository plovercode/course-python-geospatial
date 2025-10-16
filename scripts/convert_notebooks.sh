# run this from the the top-level directory
# it creates there a notebooks/ and _solved/solutions/ dir
# that get automatically copied to the correct places

if [ "$#" -ne 1 ]; then
    echo "You must enter exactly one command line argument for the course edition"
    exit 1
fi

export COURSE_DIR="DS-python-geospatial-$1"

echo "Preparing course materials for $COURSE_DIR"
echo ""
echo "-- Creating temporary directory to generate course materials"
mkdir temp_course_setup
pushd temp_course_setup

# cloning repositories to make sure we start with a clean state
echo ""
echo "-- Cloning repositories"
git clone --depth 1 https://github.com/plovercode/DS-python-geospatial.git $COURSE_DIR
git clone --depth 1 https://github.com/plovercode/course-python-geospatial.git course-python-geospatial-clean

# copying all necessary files to the course directory
echo ""
echo "-- Copying files to $COURSE_DIR"
cp course-python-geospatial-clean/notebooks/*.ipynb $COURSE_DIR/_solved/
cp course-python-geospatial-clean/notebooks/data/ $COURSE_DIR/notebooks/ -r
cp course-python-geospatial-clean/img/ $COURSE_DIR/ -r
cp course-python-geospatial-clean/environment.yml $COURSE_DIR/
cp course-python-geospatial-clean/check_environment.py $COURSE_DIR/

# converting notebooks with solutions to student notebooks
echo ""
echo "-- Converting notebooks"
pushd $COURSE_DIR/

declare -a arr=(
   "00-jupyter_introduction.ipynb"
   "01-introduction-tabular-data.ipynb"
   "02-introduction-geospatial-data.ipynb"
   "03-coordinate-reference-systems.ipynb"
   "04-spatial-relationships-joins.ipynb"
   "05-spatial-operations-overlays.ipynb"
   "10-introduction-raster.ipynb"
   "11-xarray-intro.ipynb"
   "12-xarray-advanced.ipynb"
   "13-raster-processing.ipynb"
   "14-combine-data.ipynb"
   "15-xarray-dask-big-data.ipynb"
   "90_package_numpy.ipynb"
   "91_package_rasterio.ipynb"
   "case-argo-sea-floats.ipynb"
   "case-curieuzeneuzen-air-quality.ipynb"
   "case-sea-surface-temperature.ipynb"
   "visualization-01-matplotlib.ipynb"
   "visualization-02-geopandas.ipynb"
   "visualization-03-cartopy.ipynb"
   "visualization-04-interactive.ipynb"
)

cd _solved
mkdir ./notebooks

for i in "${arr[@]}"
do
   echo "---- Converting " "$i"
   jupyter nbconvert --to=notebook --config ../../../nbconvert_config.py --output "notebooks/$i" "$i"
done

echo ""
echo "-- Copying converted notebooks and solutions"
cp -r notebooks/. ../notebooks
cp -r _solutions/. ../notebooks/_solutions

rm -r notebooks/
rm -r _solutions/

cd ..

# clear output from solved notebooks
jupyter nbconvert --clear-output _solved/*.ipynb

popd
popd

echo ""
echo "-- Moving $COURSE_DIR to top-level directory and cleaning up temporary files"
mv ./temp_course_setup/$COURSE_DIR/ ../../$COURSE_DIR
rm -rf temp_course_setup/

echo ""
echo "-- Committing changes"
cd ../../$COURSE_DIR
git checkout -b update-$1
git commit -am "$1 edition - update materials"

echo ""
echo "-- Course materials are ready in:"
echo ""
echo "   cd $(pwd)"
echo ""
echo "   Remember to push the changes to GitHub:"
echo ""
echo "   git push origin main:update-$1"
