package dartagnan.utils;

/*
******************************************************************************
*                                                                            *
*                    (c) Copyright Laszlo Szathmary                          *
*                                                                            *
* This program is free software; you can redistribute it and/or modify it    *
* under the terms of the GNU Lesser General Public License as published by   *
* the Free Software Foundation; either version 2.1 of the License, or        *
* (at your option) any later version.                                        *
*                                                                            *
* This program is distributed in the hope that it will be useful, but        *
* WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY *
* or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public    *
* License for more details.                                                  *
*                                                                            *
* You should have received a copy of the GNU Lesser General Public License   *
* along with this program; if not, write to the Free Software Foundation,    *
* Inc., 675 Mass Ave, Cambridge, MA 02139, USA.                              *
*                                                                            *
******************************************************************************
*/

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;

/**
* <dl>
* <dt>Purpose: GraphViz Java API
* <dd>
*
* <dt>Description:
* <dd> With this Java class you can simply call dot
*      from your Java programs.
* <dt>Example usage:
* <dd>
* <pre>
*    GraphViz gv = new GraphViz();
*    gv.addln(gv.start_graph());
*    gv.addln("A -> B;");
*    gv.addln("A -> C;");
*    gv.addln(gv.end_graph());
*    System.out.println(gv.getDotSource());
*
*    String type = "gif";
*    File out = new File("out." + type);   // out.gif in this example
*    gv.writeGraphToFile( gv.getGraph( gv.getDotSource(), type ), out );
* </pre>
* </dd>
*
* </dl>
*
* @version v0.5.1, 2013/03/18 (March) -- Patch of Juan Hoyos (Mac support)
* @version v0.5, 2012/04/24 (April) -- Patch of Abdur Rahman (OS detection + start subgraph + 
* read config file)
* @version v0.4, 2011/02/05 (February) -- Patch of Keheliya Gallaba is added. Now you
* can specify the type of the output file: gif, dot, fig, pdf, ps, svg, png, etc.
* @version v0.3, 2010/11/29 (November) -- Windows support + ability to read the graph from a text file
* @version v0.2, 2010/07/22 (July) -- bug fix
* @version v0.1, 2003/12/04 (December) -- first release
* @author  Laszlo Szathmary (<a href="jabba.laci@gmail.com">jabba.laci@gmail.com</a>)
*/
public class GraphViz {
 /**
  * The dir. where temporary files will be created.
  */
private static String TEMP_DIR = "./";

  /**
  * The source of the graph written in dot language.
  */
 private StringBuilder graph = new StringBuilder();

 /**
  * Constructor: creates a new GraphViz object that will contain
  * a graph.
  */
 public GraphViz() {
 }

 /**
  * Returns the graph's source description in dot language.
  * @return Source of the graph in dot language.
  */
 public String getDotSource() {
     return this.graph.toString();
 }

  /**
  * Adds a string to the graph's source (with newline).
  */
 public void addln(String line) {
     this.graph.append(line + "\n");
 }

 /**
  * Writes the source of the graph in a file, and returns the written file
  * as a File object.
  * @param str Source of the graph (in dot language).
  * @return The file (as a File object) that contains the source of the graph.
  */
 public File writeDotSourceToFile(String str) throws java.io.IOException
 {
     File temp;
     try {
         temp = File.createTempFile("dorrr",".dot", new File(GraphViz.TEMP_DIR));
         FileWriter fout = new FileWriter(temp);
         fout.write(str);
                    BufferedWriter br=new BufferedWriter(new FileWriter("dotsource.dot"));
                    br.write(str);
                    br.flush();
                    br.close();
         fout.close();
     }
     catch (Exception e) {
         System.err.println("Error: I/O error while writing the dot source to temp file!");
         return null;
     }
     return temp;
 }

 /**
  * Returns a string that is used to start a graph.
  * @return A string to open a graph.
  */
 public String start_graph() {
     return "digraph G {";
 }

 /**
  * Returns a string that is used to end a graph.
  * @return A string to close a graph.
  */
 public String end_graph() {
     return "}";
 }

 /**
  * Takes the cluster or subgraph id as input parameter and returns a string
  * that is used to start a subgraph.
  * @return A string to open a subgraph.
  */
 public String start_subgraph(int clusterid) {
     return "subgraph cluster_" + clusterid + " {";
 }

 /**
  * Returns a string that is used to end a graph.
  * @return A string to close a graph.
  */
 public String end_subgraph() {
     return "}";
 }
}