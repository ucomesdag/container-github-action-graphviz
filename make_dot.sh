#!/bin/sh

this_role=$(cat meta/main.yml | shyaml get-value galaxy_info.role_name)
this_namespace=$(cat meta/main.yml | shyaml get-value galaxy_info.namespace)
output_file=requirements.dot

cat << EOF > "${output_file}"
graph {

  node [margin="0.05,0.09" height=0 width=0 shape=box fontname="Sans serif" fontsize="9.5"];

  fontsize="8.5";
  fontname="Sans serif";

  label="ansible role dependencies";

  layout=dot;
  splines=compound;
  concentrate=true;
  center=treu;
  dpi=300;

  {
    "${this_namespace}.${this_role}"
EOF

collections=$(cat requirements.yml | shyaml get-value collections | sed 's/\[\]//')
roles=$(cat requirements.yml | shyaml get-value roles | sed 's/\[\]//')

if [ ! -f requirements.yml ] || \
      ( [ "$collections" == "" ] && [ "$roles" == "" ] ); then
  echo "    \"none\" [shape=plaintext] " >> "${output_file}"
  echo "  }" >> "${output_file}"
  echo "  \"${this_namespace}.${this_role}\" -- \"none\"" >> "${output_file}"
  echo "}" >> "${output_file}"
  exit
fi

if [ "$collections" != "" ]; then
  echo "$collections" | while read dash name collection rest ; do
    if [[ ${collection} =~ ${this_namespace}.* ]] ; then
      echo "    \"${collection}\" [label=<${collection}<BR /><FONT POINT-SIZE=\"8\">collection</FONT>>]" >> "${output_file}"
    else
      echo "    \"${collection}\" [style=filled fillcolor=grey85] [label=<${collection}<BR /><FONT POINT-SIZE=\"8\">collection</FONT>>]" >> "${output_file}"
    fi
  done
fi

if [ "$roles" != "" ]; then
  echo "$roles" | while read dash name role rest ; do
    if [[ ${role} =~ ${this_namespace}.* ]] ; then
      echo "    \"${role}\" [label=<${role}<BR /><FONT POINT-SIZE=\"8\">role</FONT>>]" >> "${output_file}"
    else
      echo "    \"${role}\" [style=filled fillcolor=grey85] [label=<${role}<BR /><FONT POINT-SIZE=\"8\">role</FONT>>]" >> "${output_file}"
    fi
  done
fi

echo "  }" >> "${output_file}"

if [ "$collections" != "" ]; then
  echo "$collections" | while read dash name collection rest ; do
    echo "  \"${collection}\" -- \"${this_namespace}.${this_role}\"" >> "${output_file}"
  done
fi

if [ "$roles" != "" ]; then
  echo "$roles" | while read dash name role rest ; do
    echo "  \"${this_namespace}.${this_role}\" -- \"${role}\"" >> "${output_file}"
  done
fi

echo "}" >> "${output_file}"
