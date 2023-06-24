# TODO: varnish versions management

getVarnish() {
  ### VARNISH
  VARNISH_VERSION="6.0"
  VARNISH_DIR="./projects/$NAME/varnish/$VARNISH_VERSION"
  VARNISH_FILE="$VARNISH_DIR/default.vcl"
  mkdir -p $VARNISH_DIR
  touch $VARNISH_FILE
}